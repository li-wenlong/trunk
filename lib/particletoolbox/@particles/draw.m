function varargout = draw(these, varargin)

plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];
scale  = 1;

figureHandle = [];
axisHandle = [];
plotHandle = [];
postcommands = '';
precommands = '';
isEval = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'axis'}
                if argnum + 1 <= nvarargin
                    axisHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'figure'}
                if argnum + 1 <= nvarargin
                    figureHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'eval'}
                if argnum + 1 <= nvarargin
                    evalpts = varargin{argnum+1};
                    isEval = 1;
                    argnum = argnum + 1;
                end
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
                    argnum = argnum + 1;
                end
                
            case {'postcommands'}
                if argnum + 1 <= nvarargin
                    postcommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    plotOpt = varargin(argnum+1);
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'scale'}
                if argnum + 1 <= nvarargin
                    scale = varargin{argnum+1};
                    argnum = argnum + 1;
                end
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;   
end

Nc = length( these );

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = repmat( [gca], 1, Nc);
end

for k=1:Nc
    [d] = these(k).getstatedims;
    if d>=2
        dstates_ = [these(k).states(dims,:); these(k).weights'*scale ];
    else
        if ~isEval
            dstates_ = [these(k).states([1],:); zeros( 1, Nc); these(k).weights'*scale ];
        else
            ypts = these(k).evaluate( evalpts );
        end
        
    end
    axes(axisHandle(k));
    if ~isempty(precommands)
        eval(precommands);
    end
    hold on
    grid on
    if d==1 && isEval
        eval(['plotHandle(k) = plot( evalpts, ypts,', plotOpt{1},');'] );
    else
        eval(['plot3(dstates_(1,:), dstates_(2,:), dstates_(3,:),', plotOpt{1},');'] )
    end
    if ~isempty(postcommands)
        eval( postcommands)
    end
    hold off
end

if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end

if nargout>=3
    varargout{3} = plotHandle;
end
