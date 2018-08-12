function varargout = drawpixtiles(this, varargin )


% plotOpt = {{'b.'},{'r.'},{'g.'},{'m.'},{'y.'},...
%     {'c.'},{'k.'},{'bo'},{'ro'},{'go'},...
%     {'mo'},{'yo'},{'co'},{'ko'},{'bx'},...
%     {'rx'},{'gx'},{'mx'},{'yx'},{'cx'},...
%     {'kx'},{'bp'},{'rp'},{'gp'},{'mp'},...
%     {'yp'},{'cp'},{'kp'}};

plotOpt = {'''b.''','''r.''','''g.''','''m.''','''y.''',...
    '''c.''','''k.''','''bo''','''ro''','''go''',...
    '''mo''','''yo''','''co''','''ko''','''bx''',...
    '''rx''','''gx''','''mx''','''yx''','''cx''',...
    '''kx''','''bp''','''rp''','''gp''','''mp''',...
    '''yp''','''cp''','''kp'''};

isonlyx = 0;
isonlyy = 0;
isonlyz = 0;
isoveridecolor = 0;

figureHandle = [];
axisHandle = [];
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyx' )
            isonlyx =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyy' )
            isonlyy =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyz' )
            isonlyz = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'overidecolor' )
            isoveridecolor = varargin{cnt+1};
            
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

for i=1:length( plotOpt )
    plotOpt{i} = [ plotOpt{i},',''Marker'',''x'''];
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end
if ~isempty(this.srbuffer)
  % Get the sensor report
    srep = this.srbuffer(1);

    pstate = srep.pstate;
    sstate = srep.sstate;

    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);

    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
end

axes(axisHandle);
hold on
grid on

rowlist = unique( [ [this.numrows:-floor(this.numrows/10):1], 1],'legacy' );
colist = unique( [ [this.numcols:-floor(this.numcols/10):1], 1],'legacy' );
for i=1:length(rowlist)
    for j=1:length(colist)
        
        rownum = rowlist( i );
        colnum = colist( j );
          
        % Get the unit vectors from the edges of the pixel passing through the origin in sensor coordinate system
        esS = this.pixvector( rownum, colnum );
        
        % Convert these vectors to Earth Coordinates
        esE = R_BE'*R_SB'*esS;
                
        % Find the points on the z = 0 plane that intersects with these
        % unit vectors
        
        isonsurface = 1;
        pointsonsurface = [];
        for k=1:size( esE , 2 )
            [intersect_point, w] = interwxy( pstate.location + R_BE'*sstate.location, esE(:, k) );
            if isempty( intersect_point ) || w<0
                isonsurface = 0;
                break;
            end
            if w<0
                warning('The unit vector is not headed towards the xy plane!')
            end
            pointsonsurface = [pointsonsurface, intersect_point];
        end
        
        if ~isonsurface
            continue;
        end
        
        
         
        plotOpts = [plotOpt{1}, ',''marker'',''none'',''linestyle'',''-'''];
       
        
        eval(['plot3(pointsonsurface(1,[1 2]), pointsonsurface(2,[1 2]), pointsonsurface(3,[1 2]),', plotOpts ,');'] )
        eval(['plot3(pointsonsurface(1,[2 3]), pointsonsurface(2,[2 3]), pointsonsurface(3,[2 3]),', plotOpts ,');'] )
        eval(['plot3(pointsonsurface(1,[3 4]), pointsonsurface(2,[3 4]), pointsonsurface(3,[3 4]),', plotOpts ,');'] )
        eval(['plot3(pointsonsurface(1,[4 1]), pointsonsurface(2,[4 1]), pointsonsurface(3,[4 1]),', plotOpts ,');'] )
        
    end
    
end
hold off
