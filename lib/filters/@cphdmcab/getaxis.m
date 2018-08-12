function varargout = getaxis(this, varargin )



figureHandle = [];
axisHandles = [];
axis4all = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    
    switch lower(varargin{argnum})
        
        case {'figure'}
            if argnum + 1 <= nvarargin
                figureHandle = varargin{argnum+1};
                argnum = argnum + 1;
            end
        case {'all'}
            axis4all = 1;
            
        case {''}
            
       
        otherwise
            error('Wrong input string');
    end
    argnum = argnum + 1;
    
end


    if isempty(figureHandle)
        figureHandle = figure;
        set( figureHandle, 'DoubleBuffer','on');
    end
    figure(figureHandle)
    clf

if ~axis4all
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
            axisHandles( (cnt2-1)*numRows + cnt ) = axes( 'position',  [ colLefts(cnt), rowFloors(cnt2), colWidth, rowHeights ], ...
                'FontSize', 0.8 );
            hold on
        end
    end
else
  % Prepare 6 axis

    screenSize = get( get( figureHandle, 'Parent'), 'ScreenSize' );
    height2Width = screenSize(4)/screenSize(3);
    height2WidthReal = screenSize(4)/screenSize(3);

    width = 0.6;
    height = (2/3*0.6)/height2WidthReal;

    figurePosition = [0.1 0.1 width height];
    realFigurePosition = round( [screenSize(3) screenSize(4) screenSize(3) screenSize(4)].*figurePosition ) ;
    set( figureHandle, 'Position', realFigurePosition );

    horizontalMargin = 0.05;
    numCols = 3;
    colLefts = [ 0.05,  0.3667, 0.6834 ];
    colWidth = 0.2667;

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
            axisHandles( (cnt2-1)*numCols + cnt ) = axes( 'position',  [ colLefts(cnt), rowFloors(cnt2), colWidth, rowHeights ], ...
                'FontSize', 0.8 );
            hold on
        end
    end


end

if nargout>=1
    varargout{1} = axisHandles;
end
if nargout>=2
    varargout{2} = figureHandle;
end
