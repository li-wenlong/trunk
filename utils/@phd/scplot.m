function varargout = scplot( phd, varargin)

nvarargin = length(varargin);
argnum = 1;
plotOpt = '''Color'',[0 0 1],''Marker'',''x''';
figureHandle = [];
axisHandle = [];
dims = [1,2]';
postcommands = '';
precommands = '';
calldrawc = 0;
scalefactor = phd.mu;
legendOn = '';

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
                    plotOpt = [plotOpt,',',varargin{argnum+1}];
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'scale'}
                if argnum + 1 <= nvarargin
                    scalefactor = scalefactor*varargin{argnum+1};
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
    figure(figureHandle)
    clf
    % Prepare the axis
    axisHandle = gca;
    else
   
end


[axisHandle, figureHandle] = phd.s.scplot('axis', axisHandle, ...
        'dims', dims, ...
        'precommands', precommands, ...
        'postcommands', postcommands,...
        'options', plotOpt,...
        'scale', scalefactor...
        );




if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end