function varargout = fun_plotsensordata( sensors, varargin )



isSameFigure = 1;

figureHandles = [];
axisHandles = [];
postcommands = '';
precommands = '';


nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
     if isa( lower(varargin{argnum}), 'char')
         switch lower(varargin{argnum})
             case {'figure'}
                 if argnum + 1 <= nvarargin
                     figureHandles = varargin{argnum+1};
                     argnum = argnum + 1;
                 end 
              case {'samefigure'}
                 isSameFigure = 1;
                 argnum = argnum + 1;
                
             case {'postcommands'}
                 if argnum + 1 <= nvarargin
                     postcommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'precommands'}
                 if argnum + 1 <= nvarargin
                     precommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
            case {'options'}
                 if argnum + 1 <= nvarargin
                     plotOpt = [plotOpt,',', varargin{argnum+1}];
                     argnum = argnum + 1;
                 end      
             otherwise
                 error('Wrong input string');
         end
     end
     argnum = argnum + 1;
end

N = length( sensors );

if isempty(figureHandles)
    if isSameFigure
        figureHandles(1) = figure;
        set( figureHandles(1), 'doublebuffer', 'on' );
        set( figureHandles(1), 'doublebuffer', 'on' );
        set( figureHandles(1), 'Color', [1 1 1] );
        
        for k=2:N
            figureHandles(k) = figureHandles(1);
        end
    else    
        for k=1:N
            figureHandles(k) = figure;
            set( figureHandles(k), 'doublebuffer', 'on' );
            set( figureHandles(k), 'doublebuffer', 'on' );
            set( figureHandles(k), 'Color', [1 1 1] );
            
            screenSize = get( get( figureHandles(k), 'Parent'), 'ScreenSize' );
            
            height2Width = screenSize(4)/screenSize(3);
            height2WidthReal = screenSize(4)/screenSize(3);
            
            width = 0.3;
            height = width/height2WidthReal;
            
            figurePosition = [(0.2+ (k-1)*0.05 )  (0.3 + (k-1)*0.05 ) width height];
            realFigurePosition = round( [screenSize(3) screenSize(4) screenSize(3) screenSize(4)].*figurePosition ) ;
            set( figureHandles(k), 'Position', realFigurePosition );
        end
    end   
else
    if length(figureHandles)~= N
        error('Number of figure handles %d must match the number of sensors %d !',length(figureHandles),N);
    end
end

% Fetch sensor measurements into arrays and also fetch their timestamps
measurements = {};
timestamps = {};
for i=1:length( sensors )
    cartmeas = sensors{i}.srbuffer.getcat;
    measurements{i} = cartmeas;
    timestamps{i} = sensors{i}.srbuffer.gettimestamps;
end


    
mymap = [[0 0 1];[1 0 0];[0 1 0];[1 0 1];[0 0 0];[0 1 1]];

for k=1:N
        
    nodei = k;
    rownumi = nodei;
    
    figure( figureHandles( nodei ) );
    hold on 
    grid on
    plot( measurements{nodei}(1,:),measurements{nodei}(2,:),'.','Color', mymap( rownumi, : ) );
    drawnow
end


if nargout>=1
    varargout{1} =  figureHandles;
end





