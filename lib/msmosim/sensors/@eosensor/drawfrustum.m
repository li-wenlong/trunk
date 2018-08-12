function varargout = draw(this, pstate, varargin )


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
        elseif  strcmp( lower( varargin{cnt} ), 'pixelcentre' )
            ispixelcentre = varargin{cnt+1};
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

axes(axisHandle);
hold on
grid on

sstate = kstate;
sstate.substate( this.location, {'x','y','z'});
sstate.substate( this.orientation, {'psi','theta','phi'});
sstate.setvelearth( this.velearth );
sstate.catstate;


plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );

esS1 = this.pixvector( 1,1 );
esS1 = esS1/norm(esS1);
esS2 = this.pixvector( 1, this.numcols );
esS2 = esS2/norm(esS2);
esS3 = this.pixvector( this.numrows, this.numcols );
esS3 = esS3/norm(esS3);
esS4 = this.pixvector( this.numrows, 1 );
esS4 = esS4/norm(esS4);

esS = [esS1(:,1), esS2(:,2), esS3(:,3), esS4(:,4)];
% Convert these vectors to Earth Coordinates
esE = R_BE'*R_SB'*esS;

apos = pstate.location + R_BE'*sstate.location; % Aperture position

frustumPoints =  [ repmat( apos, 1, 4) + esE*this.minrange,...
    repmat( apos, 1, 4) + esE*this.maxrange ];  

plotOpts = [plotOpt{1}, ',''marker'',''none'',''linestyle'',''-'''];


eval(['plot3( apos(1), apos(2), apos(3),', [plotOpts,',''marker'',''s'''] ,');'] )

eval(['plot3( frustumPoints(1,[1 2]), frustumPoints(2,[1 2]), frustumPoints(3, [1 2]),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[2 3]), frustumPoints(2,[2 3]), frustumPoints(3,[2 3]),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[3 4]), frustumPoints(2,[3 4]), frustumPoints(3,[3 4]),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[4 1]), frustumPoints(2,[4 1]), frustumPoints(3,[4 1]),', plotOpts ,');'] )

eval(['plot3( frustumPoints(1,[1 2] + 4), frustumPoints(2,[1 2] + 4), frustumPoints(3, [1 2] + 4),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[2 3] + 4), frustumPoints(2,[2 3]+ 4), frustumPoints(3,[2 3]+ 4),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[3 4]+ 4), frustumPoints(2,[3 4]+ 4), frustumPoints(3,[3 4]+ 4),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[4 1]+ 4), frustumPoints(2,[4 1]+ 4), frustumPoints(3,[4 1]+ 4),', plotOpts ,');'] )

eval(['plot3( frustumPoints(1,[1 5]), frustumPoints(2,[1 5]), frustumPoints(3, [1 5] ),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[2 6] ), frustumPoints(2,[2 6]), frustumPoints(3,[2 6]),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[3 7] ), frustumPoints(2,[3 7]), frustumPoints(3,[3 7]),', plotOpts ,');'] )
eval(['plot3(frustumPoints(1,[4 8] ), frustumPoints(2,[4 8]), frustumPoints(3,[4 8]),', plotOpts ,');'] )

    
hold off
