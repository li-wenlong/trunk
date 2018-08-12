function varargout = draw( this, varargin )


% plotOpt = {{'b.'},{'r.'},{'g.'},{'m.'},{'y.'},...
%     {'c.'},{'k.'},{'bo'},{'ro'},{'go'},...
%     {'mo'},{'yo'},{'co'},{'ko'},{'bx'},...
%     {'rx'},{'gx'},{'mx'},{'yx'},{'cx'},...
%     {'kx'},{'bp'},{'rp'},{'gp'},{'mp'},...
%     {'yp'},{'cp'},{'kp'}};

% plotOpt = {'b.','r.','g.','m.','y.',...
%     'c.','k.','bo','ro','go',...
%     'mo','yo','co','ko','bx',...
%     'rx','gx','mx','yx','cx',...
%     'kx','bp','rp','gp','mp',...
%     'yp','cp','kp'};

MarkerOpts = {'''Marker'',''.''',...
    '''Marker'',''>''',...
    '''Marker'',''o''',...
    '''Marker'',''x''',...
    '''Marker'',''p''',...
    '''Marker'',''s''',...
    '''Marker'',''<''',...
    '''Marker'',''h''',...
    '''Marker'',''d'''};

ColorArray = [ 0.5 0.5 0.5
   0.5 0.5 1
   0.5 1 0.5
   0.5 1 1
   1 0.5 0.5
   1 0.5 1
   1 1  0.5
    0.25 0.25 1
    0.25 1 0.25
    0.25 1 1
    0 0 1 % 1 BLUE
   0 1 0 % 2 GREEN (pale)
   1 0 0 % 3 RED
   0 1 1 % 4 CYAN
   1 0 1 % 5 MAGENTA (pale)
   1 1 0 % 6 YELLOW (pale)
   0 0 0 % 7 BLACK
   0 0.75 0.75 % 8 TURQUOISE
   0 0.5 0 % 9 GREEN (dark)
   0.75 0.75 0 % 10 YELLOW (dark)
   1 0.50 0.25 % 11 ORANGE
   0.75 0 0.75 % 12 MAGENTA (dark)
   0.7 0.7 0.7 % 13 GREY
   0.8 0.7 0.6 % 14 BROWN (pale)
   0.6 0.5 0.4  % 15 BROWN (dark)
   ];

for i=1:30
    plotOpts{i} = { ['''Color'',[', num2str(ColorArray(mod(i-1,25)+1 ,:)),'],',MarkerOpts{mod(i-1,9)+1 }] };
end

% plotOpt = {'''b.''','''r.''','''g.''','''m.''','''y.''',...
%     '''c.''','''b>''','''r>''','''g>''',...
%     '''m>''','''y>''','''c>''','''k>''','''bo''',...
%     '''ro''','''go''','''mo''','''yo''','''co''',...
%     '''kx''','''bp''','''rp''','''gp''','''mp''',...
%     '''yp''','''cp''','''kp'''};

plotOpt = {};
for i=1:length( plotOpts )
    plotOpt{i} = [ plotOpts{i},',''MarkerSize'',15'];
end

figureHandle = [];
axisHandle = [];
excludePlat = [];
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
         elseif strcmp( lower( varargin{cnt} ), 'exclude' )
            excludePlat  = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

plotOptCnt  = 1;

for cnt = 1:length(this.platforms)
    if ~isempty( find( cnt == excludePlat ) )
        plotOptCnt = plotOptCnt+1;
        if plotOptCnt> length(plotOpt)
            plotOptCnt = 1;
        end
        continue;
    end
    this.platforms{cnt}.draw( 'axis', axisHandle, 'options', plotOpt{plotOptCnt} );
    drawnow;
    plotOptCnt = plotOptCnt+1;
    if plotOptCnt> length(plotOpt)
        plotOptCnt = 1;
    end
end
    