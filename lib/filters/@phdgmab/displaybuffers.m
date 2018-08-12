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
    plotOpts{1} =  ['''LineStyle'',''None'',''Marker'',''.'',''Color'',''k'',',plotOpt{1}];
else
    plotOpts{1} =  ['''LineStyle'',''None'',''Marker'',''.'',''Color'',''k'''];
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
    plotOpts{4} =  ['''LineStyle'',''None'',''Marker'',''.'',''Color'',''g'',',plotOpt{4}]; 
else
    plotOpts{4} =  ['''LineStyle'',''None'',''Marker'',''.'',''Color'',''g'''];
end

if isempty(axisHandles)
    if isempty(figureHandle)
        figureHandle = figure;
        set( figureHandle, 'DoubleBuffer','on');
    end
    figure(figureHandle)
    clf
    % Prepare the axis

    screenSize = get( get( figureHandle, 'Parent'), 'ScreenSize' );
    height2Width = screenSize(4)/screenSize(3);
    height2WidthReal = screenSize(4)/screenSize(3);

    width = 0.6;
    height = 2*0.3/height2WidthReal;

    figurePosition = [0.1 0.1 width height];
    realFigurePosition = round( [screenSize(3) screenSize(4) screenSize(3) screenSize(4)].*figurePosition ) ;
    set( figureHandle, 'Position', realFigurePosition );

    horizontalMargin = 0.05;
    numCols = 2;
    colLefts = [ 0.05 0.5275];
    colWidth = 0.4225;

    verticalMargin = 0.05;
    numRows = 2;
    rowButtoms = 0.1;
    rowHeights = 0.4;
    rowFloors = [rowButtoms , verticalMargin+rowButtoms+rowHeights ];

    axisHandles = [];
    verticalMargin = 0.1;
    for cnt2 = 1:numRows
        for cnt = 1:numCols

            figure(figureHandle);
            axisHandles( (cnt2-1)*numCols + cnt ) = axes( 'position',  [ colLefts(cnt), rowFloors(cnt2), colWidth, rowHeights ] );
            set( axisHandles( (cnt2-1)*numCols + cnt ),  'FontSize', get(axisHandles( (cnt2-1)*numCols + cnt ),'FontSize')*0.8 ); 
            hold on
        end
    end
end

if isempty(stepNum)
    if ~isempty( this.predintbuffer )
        pred = this.predintbuffer{end};
    else
        pred = [];
    end
    if ~isempty( this.predcardbuffer )
        predcard = this.predcardbuffer{end};
    else
        predcard = [];
    end 
    if ~isempty( this.postintbuffer )
        post = this.postintbuffer{end};
    else
        post = [];
    end
    if ~isempty(this.postcardbuffer )
        postcard = this.postcardbuffer{end};
    else
        postcard = [];
    end
else
    pred = this.predintbuffer{stepNum};
    predcard = this.predcardbuffer{stepNum};
    post = this.postintbuffer{stepNum};
    postcard = this.postcardbuffer{stepNum};
end 

if ~isempty(pred) && axisHandles(1) ~= 0
    % Draw the prediceted intensity particles    
    pred.draw( 'axis', axisHandles(1) ,'options', plotOpts{1} ,'postcommands', postcommands, 'precommands', precommands, 'dims', dims, 'gmm' );
    axes( axisHandles(1) );
  %  ax_ = axis;
  %  ax_(1:4) = [-6000,6000,-6000,6000];
  %  axis(ax_)
    
    title('Predicted Density');
end

if ~isempty(predcard ) && axisHandles(2)~=0
    axes( axisHandles(2) );
    if ~isempty(precommands)
        eval( precommands );
    end
    grid on
    hold on
    eval([' plot([0:length(predcard)-1],predcard,', plotOpts{2},');'] );
    
    title('Predicted Cardinality');
end

if ~isempty( post ) && axisHandles(3) ~= 0
      
    post.draw('axis', axisHandles(3), 'options', plotOpts{1} , 'postcommands', postcommands ,  'precommands', precommands, 'dims', dims, 'gmm' );
    axes( axisHandles(3) );
   % ax_ = axis;
   % ax_(1:4) = [-6000,6000,-6000,6000];
   % axis(ax_)
    
    title('Posterior Density');

end


if ~isempty( postcard ) &&  axisHandles(4) ~= 0
    axes( axisHandles(4) );
    if ~isempty(precommands)
        eval( precommands );
    end
    grid on
    hold on
     eval([' plot( [0:length(postcard)-1], postcard,', plotOpts{3},');'] );
    title('Posterior Cardinality');
end    

if nargout>=1
    varargout{1} = axisHandles;
end
if nargout>=2
    varargout{2} = figureHandle;
end
