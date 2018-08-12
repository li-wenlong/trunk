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
    timesteps = [length(this.srbuffer)];
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
cla;
hold on;

for kk = 1:length( timesteps )
    i = timesteps(kk);
    
    % Get the sensor report
    srep = this.srbuffer(i);


    imagesc( srep.Z,[0 3] )
    
    
    [M,N] = size(  srep.Z );
    % Cross the givens
    gind =  find(srep.given(:)~=0);
    for j=1:length(gind)
        gcol = rem(gind,M);
        grow = floor(gind/M) + 1;
        if gcol == 0;
            grow = grow - 1;
            gcol = M;
        end
        
        plot( grow, gcol , 'Marker','o','Markersize',9,'LineWidth',2.25,'Color',[1 1 1]);
    end
    
    
end
xlabel('\phi')
ylabel('R')
axis tight
set( axisHandle,'xticklabel',[],'yticklabel',[])
hold off
