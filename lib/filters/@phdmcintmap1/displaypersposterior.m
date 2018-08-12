function varargout = displaypersposterior(this, varargin )


plotOpt = '';
dims = [1,2]';
figureHandle = [];
axisHandles = [];
stepNum = [];
postcommands = '';
precommands = '';
calldrawc = '';
legendOn = '';

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    
    switch lower(varargin{argnum})
        case {'axis'}
            if argnum + 1 <= nvarargin
                axisHandles = varargin{argnum+1};
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
        case {'step'}
            if argnum + 1 <= nvarargin
                stepNum = varargin{argnum+1};
                argnum = argnum + 1;
            end
        case {'clusters'}
            calldrawc = 'clusters';
            
        case {'legend'}
            legendOn = 'legend';
            
        case {''}
            
       
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
    
end

if ~isempty( plotOpt )
    plotOpts =  ['''LineStyle'',''None'',''Marker'',''x'',''Color'',[0 0 0],',plotOpt];
else
    plotOpts =  ['''LineStyle'',''None'',''Marker'',''x'',''Color'',[0 0 0]'];
end


% Make the figure and the axis ready

if isempty(axisHandles)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    figure(figureHandle)
    clf
    axisHandles = gca;
end

if ~isempty(this.postintensity)
   
    this.postintensity.scplot('axis', axisHandles(1), 'options', plotOpts , 'postcommands', postcommands ,  ...
        'precommands', precommands, 'dims',dims, calldrawc, legendOn  );

end



if nargout>=1
    varargout{1} = axisHandles;
end

if nargout>=2
varargout{2} = figureHandle;
end
