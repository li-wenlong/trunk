function varargout = scplot(pdf, varargin)


plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];
scale = 1;

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
calldrawc = 0;
legendOn = '';

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
            case {'clusters'}
                calldrawc = 1;
                
            case {'legend'}
                legendOn = 'legend';
                
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

if ~calldrawc
[axisHandle, figureHandle ] = pdf.particles.draw(...
    'axis', axisHandle, ...
    'scale',scale,...
    'dims', dims, ...
    'precommands', precommands, ...
    'postcommands', postcommands,...
    'options', plotOpt{1}...
    );
else
[axisHandle, figureHandle ] = pdf.particles.drawc(...
    'axis', axisHandle, ...
    'scale', scale,...
    'dims', dims, ...
    'precommands', precommands, ...
    'postcommands', postcommands,...
    'options', plotOpt{1},...
    legendOn...
    );
end



if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end
