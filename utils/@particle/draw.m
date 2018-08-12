function varargout = draw(these, varargin)

states_ = these.catstates;
weights = these.catweights;

plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];

figureHandle = [];
axisHandle = [];

postcommands = '';
precommands = '';


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
                    plotOpt = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;   
end


if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end


[d, Nc] = size(states_);
if d>=2
    dstates_ = [states_([1,2],:); weights' ];
else
    dstates_ = [states_([1],:); zeros( 1, Nc); weights' ];
end
axes(axisHandle);
if ~isempty(precommands)
    eval(precommands);
end
hold on
grid on
eval(['plot3(dstates_(1,:), dstates_(2,:), dstates_(3,:),', plotOpt{1},');'] )
if ~isempty(postcommands)
    eval( postcommands)
end
hold off

if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end

