function varargout = draw(pdf, varargin)

if ~isempty( pdf.gmm )
    
    [axisHandle, figureHandle]  = pdf.gmm.draw( varargin{:} );
    
    if nargout>=1
        varargout{1} = axisHandle;
    end
    if nargout>=2
        varargout{2} = figureHandle;
    end
    
    return;
end

plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];
scale = 1;

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';

isGMM = 0;
isKDE = 1;
clearAxis = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( lower(varargin{argnum}), 'char')
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
                    if ~isempty( varargin{argnum+1} )
                        plotOpt = varargin(argnum+1);
                    end
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
            case {'gmm'}
                isGMM = 1;
                isKDE = 0;
                
            case {'kde'}
                isKDE = 1;
                isGMM = 0;                
            case {'legend'}
                legendOn = 1;
                
            case {''}
                
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

if isKDE &&  ~isempty(pdf.kde)
    zs = pdf.evaluate('kde');
elseif isGMM && ~isempty(pdf.gmm)
    zs = pdf.evaluate('gmm');
else
    return;
end
zs = zs(:)*scale;
states_ = pdf.particles.getstates;

[d, Nc] = size( states_ );
if d>=2
    dstates_ = [states_(dims,:); zs' ];
else
    dstates_ = [states_([1],:); zeros( 1, Nc); zs' ];
end
axes(axisHandle);
if ~isempty(precommands)
    eval(precommands);
end
hold on
grid on

eval(['plot3(dstates_(1,:), dstates_(2,:), dstates_(3,:),', plotOpt{1},');'] )
if ~isempty(postcommands)
   eval(postcommands); 
end
hold off

if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end
