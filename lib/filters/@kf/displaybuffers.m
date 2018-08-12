function varargout = displaybuffers(this, varargin )


plotOpt = {'','','',''};
dims = [1,2]';
figureHandle = [];
axisHandles = [];
stepNum = [];
postcommands = '';
precommands = '';

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

if length(plotOpt) == 1
    for i=2:4
        plotOpt{i} = plotOpt{1};
    end
end
if ~isempty( plotOpt{1} )
    plotOpts{1} =  ['''LineStyle'',''None'',''Marker'',''x'',''Color'',''k'',',plotOpt{1}];
else
    plotOpts{1} =  ['''LineStyle'',''None'',''Marker'',''x'',''Color'',''k'''];
end

if ~isempty( plotOpt{2} )
    plotOpts{2} =  ['''Color'',''b'',',plotOpt{2}];
else
    plotOpts{2} =  ['''Color'',''b'''];
end
if ~isempty( plotOpt{3} )
    plotOpts{3} =  ['''Color'',''b'',',plotOpt{3}];
else
    plotOpts{3} =  ['''Color'',''b'''];
end


if ~isempty(  plotOpt{4} )
    plotOpts{4} =  ['''LineStyle'',''None'',''Marker'',''s'',''Color'',''g'',',plotOpt{4}]; 
else
    plotOpts{4} =  ['''LineStyle'',''None'',''Marker'',''s'',''Color'',''g'''];
end

if isempty(axisHandles)
    axisHandles = this.getaxis('all');
end

if isempty(stepNum)
    if ~isempty( this.predbuffer )
        pred = this.predbuffer{end};
    else
        pred = [];
    end
  
    if ~isempty( this.postbuffer )
        post = this.postbuffer{end};
    else
        post = [];
    end
else
    pred = this.predbuffer{stepNum};
    post = this.postbuffer{stepNum};
end 

if ~isempty(pred) && axisHandles(1) ~= 0
    % Draw the prediceted intensity particles    
    pred.draw( 'axis', axisHandles(1) ,'options', plotOpts{1} ,'postcommands', postcommands, 'precommands', precommands, 'dims', dims );
    axes( axisHandles(1) );
  %  ax_ = axis;
  %  ax_(1:4) = [-6000,6000,-6000,6000];
  %  axis(ax_)
    
    title('Predicted Density');
end

if ~isempty( post ) && axisHandles(3) ~= 0
      
    post.draw('axis', axisHandles(3), 'options', plotOpts{1} , 'postcommands', postcommands ,  'precommands', precommands, 'dims', dims );
    axes( axisHandles(3) );
   % ax_ = axis;
   % ax_(1:4) = [-6000,6000,-6000,6000];
   % axis(ax_)
    
    title('Posterior Density');

end


if nargout>=1
    varargout{1} = axisHandles;
end
if nargout>=2
    varargout{2} = figureHandle;
end
