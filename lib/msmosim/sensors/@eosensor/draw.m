function varargout = draw(this, varargin )


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
ispixelcentre = 0;
istimestep = 0;
isOptInp  = 0;

figureHandle = [];
axisHandle = [];
nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'axis'}
                if argnum + 1 <= nvarargin
                    axisHandle = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'timesteps','timestep'}
                if argnum + 1 <= nvarargin
                    timesteps = varargin{argnum+1}(1);
                    istimestep = 1;
                    argnum = argnum + 1;
                end
            case {'figure'}
                if argnum + 1 <= nvarargin
                    figureHandle = varargin{argnum+1}(1);
                    istimestep = 1;
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    optInp = varargin{argnum+1}(1);
                    isOptInp = 1;
                    argnum = argnum + 1;
                end
            case { 'pixelcentre' }
                ispixelcentre = 1;
%             case {'overidecolor'}
%                 isoveridecolor = 1;
%             case {'bottomright'}
%                 istopleft = 0;
%                 isbottomright = 1;
%                 isbottomleft = 0;
%              case {'topleft'}
%                 istopleft = 1;
%                 isbottomright = 0;
%                 isbottomleft = 0;
            
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        
    end
    argnum = argnum + 1;
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

if ~istimestep
    timesteps = [1:length(this.srbuffer)];
end

if ispixelcentre
    plotOpts = [plotOpt{1}, ',''marker'',''.'',''linestyle'',''none'''];
else
    plotOpts = [plotOpt{1}, ',''marker'',''none'',''linestyle'',''-'''];
end
if isOptInp
    if iscell(optInp)
        plotOpts = [plotOpts, ',', optInp{1}];
    else
        plotOpts = [plotOpts, ',', optInp];
    end
end

axes(axisHandle);
hold on
grid on

for kk = 1:length( timesteps )
    i = timesteps(kk);
    
    % Get the sensor report
    srep = this.srbuffer(i);

    pstate = srep.pstate;
    sstate = srep.sstate;

    if this.insensorframe == 0
        plocE = pstate.getstate({'x','y','z'});
        angBE = pstate.getstate({'psi','theta','phi'});
        R_BE = dcm(angBE);
        
        slocB = sstate.getstate({'x','y','z'});
        angSB = sstate.getstate({'psi','theta','phi'});
        R_SB = dcm( angSB );
    else
        % The incoming particles locationE_ are already in sensor coordinate
        % system
        plocE = [0 0 0]';
        angBE = [0 0 0]';
        R_BE = eye(3);
        
        slocB = [0 0 0]';
        angSB = [0 0 0]';
        R_SB = eye(3);
    end

    for j = 1:length(srep.Z)
        % Get an observation        
        z = srep.Z(j);
        
        % Get the unit vectors from the edges of the pixel passing through the origin in sensor coordinate system
        esS = this.pixvector( z.row, z.col );
        
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
        
        
         
       
        if ~isoveridecolor
            if ~isempty( srep.given )
            if srep.given(j) == 0
                plotOpts = [plotOpts, ',''Color'',''k'''];
            end
            end
        end
        
        if ispixelcentre
            
            com_x = mean( pointsonsurface(1,[1 2 3 4]) );
            com_y = mean( pointsonsurface(2,[1 2 3 4]) );
            com_z = mean( pointsonsurface(3,[1 2 3 4]) );
            eval(['plot3( com_x, com_y, com_z,', plotOpts ,');'] )
        else
            eval(['plot3(pointsonsurface(1,[1 2]), pointsonsurface(2,[1 2]), pointsonsurface(3,[1 2]),', plotOpts ,');'] )
            eval(['plot3(pointsonsurface(1,[2 3]), pointsonsurface(2,[2 3]), pointsonsurface(3,[2 3]),', plotOpts ,');'] )
            eval(['plot3(pointsonsurface(1,[3 4]), pointsonsurface(2,[3 4]), pointsonsurface(3,[3 4]),', plotOpts ,');'] )
            eval(['plot3(pointsonsurface(1,[4 1]), pointsonsurface(2,[4 1]), pointsonsurface(3,[4 1]),', plotOpts ,');'] )
        end
    end
    
end
hold off
