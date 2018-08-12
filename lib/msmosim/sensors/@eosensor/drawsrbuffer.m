function varargout = draw(this, varargin )


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
            case {'timesteps'}
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

axes(axisHandle);
hold on
grid on

if ~istimestep
    timesteps = [1:length(this.srbuffer)];
end

plotOpts = [plotOpt{1}, ',''marker'',''.'',''linestyle'',''none'''];
if isOptInp
    if iscell(optInp)
        plotOpts = [plotOpt{1}, ',', optInp{1}];
    else
        plotOpts = [plotOpt{1}, ',', optInp];
    end
end


% The below is needed to use plot and still draw like
% imagesc, i.e., (1,1) at top left
xvals = [1:this.numcols];
yvals = [this.numrows:-1:1];      
    
for kk = 1:length( timesteps )
    i = timesteps(kk);
    
    % Get the sensor report
    srep = this.srbuffer(i);
    
    for j = 1:length(srep.Z)
        % Get an observation
        z = srep.Z(j);
        
        % Get the row and col. which are in bottom right ordering
        rowval = z.row;
        colval = z.col;
        
        if ~isoveridecolor
            if ~isempty( srep.given )
                if srep.given(j) == 0
                    plotOpts = [plotOpts, ',''Color'',''k'''];
                end
            end
        end
        
       % eval(['plot3( lrcol, udrow, 0,', plotOpts ,');'] )
       % eval(['plot3( xvals( lrcol) , yvals(udrow) , 0,', plotOpts ,');'] )
        eval(['plot3( xvals( colval), yvals( rowval ) ,0,', plotOpts ,');'] )
        
        
    end
    
end
axis([0,this.numcols,0,this.numrows])
set(gca,  'ytickLabel',flipud(get( gca, 'ytickLabel'))  );


hold off
