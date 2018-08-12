
printFigure2files = 0;

load('simdata_linear_multitarget4pmrf.mat')

% Define the graph
V = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
E = [[1 2];[2 1];[1 4];[4 1];[1 6];[6 1];[1 8];[8 1];[2 3];[3 2];[2 9];[9 2];...
    [3 4];[4 3];[4 5];[5 4];[5 6];[6 5];[6 7];[7 6];[7 8];[8 7];[8 9];[9 8];...
    [9 10];[10 9];[10 11];[11 10];[2 11];[11 2];[11 12];[12 11];[12 3];[3 12];[12 13];[13 12];...
    [13 14];[14 13];[14 3];[3 14];[15 14];[14 15];[15 4];[4 15];[15 16];[16 15];[16 5];[5 16]];
Thetas = [[0 0];[1000 0];[1000 1000];[0 1000];[-1000 1000];...
    [-1000 0];[-1000 -1000];[0 -1000];[1000 -1000];...
    [2000 -1000];[2000 0];[2000 1000];[2000 2000];...
    [1000 2000];[0 2000];[-1000 2000]];


[sensors, loc] = sim.getsensors;
locSCS = Thetas;

% The following are the offset values when writing the sensor tags on the figure
offsets = [50 120; ...
    50 120;...
    50 160;...
    50 160;...
    -200 0;... % following are for the sensors;
     -200 0;...
    -200 0;...
    -50 -200;...
    -50 -200;...
    -50 -200;...
    50 0;...
    50 0;...
    50 0;...
    50 200;...
    -50 200;... % following are for the sensors;
     -50 200;...
    ];
% The following are the offset values when writing the target tags on the
% figure
toffsets = [-200 0;
             -200 0;
             -200 0;
             -200 0
             ];

fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [1 1 1] );
screenSize = get( get( fhandle, 'Parent'), 'ScreenSize' );
height2Width = screenSize(4)/screenSize(3);
height2WidthReal = screenSize(4)/screenSize(3);

width = 0.9;
height = width*height2WidthReal*1.2;

figurePosition = [0.2 0.3 width height];
realFigurePosition = round( [screenSize(3) screenSize(4) screenSize(3) screenSize(4)].*figurePosition ) ;
set( fhandle, 'Position', realFigurePosition );
ahandle_scenario = gca;


stepcnt = 60;
axes( ahandle_scenario );
axis([-1500,2500,-1500,2500])
set( ahandle_scenario, 'FontSize',18 );
cla;
drawgeograph( loc',E ,  'AxisHandle', gca, 'Linewidth',1,'Color','b')
hold on;
grid on;
% Plot the target tracks
plotset( Xt(1:stepcnt), 'axis', gca, 'options','''Color'',[0 0 0],''MarkerSize'',2.5,''Marker'',''s'',''Linewidth'',2');

% Draw initial points of the tracks
birthtimes = [];
for k=1:4
    plat = sim.platforms{k};
    plat.track.treps(1).state.draw( 'axis', gca, 'options', {'''Color'',[0 0 0],''MarkerSize'',8,''Marker'',''s'',''Linewidth'',3' });
    birthtimes = [birthtimes, plat.track.treps(1).time];
end
[sbirthtimes,sindx] = sort(birthtimes);
% Tag the targets
for k=1:4
    textpos = sim.platforms{ sindx(k) }.track.treps(1).state.getstate({'x','y'});
    text( textpos(1)+toffsets( k , 1), textpos(2)+toffsets( k , 2), ['T', num2str(k)], 'Color', [0 0 0],'Fontsize',18 );
end


hold on;
mymap = linspecer(length( V ));
for i=1:length(sensors)
    sensori = sensors{i};
    % Plot the sensor observations
    col = mymap(i,:);
%     obs = sensori.srbuffer( stepcnt ).getxy;
%     plot(  obs(1,:), obs(2,:),'marker','x','MarkerSize',8,'Linewidth',2, 'color',col,'linestyle','none')
    % Plot the sensor positions
    plot(  sensori.srbuffer(1).pstate.location(1),  sensori.srbuffer(1).pstate.location(2),...
        'Color',[0 0 1],'MarkerSize',8,'Marker','o','Linewidth',2, 'color',col,'linestyle','none' ,'MarkerFaceColor',col);
    
    textpos = loc(:, i);
    text( textpos(1)+offsets( i , 1), textpos(2)+offsets( i , 2), ['S', num2str(i)], 'Color', [0 0 1],'Fontsize',18,'FontWeight','Bold' );
    
end

% text(2100,700,['k=',num2str(stepcnt)],'FontSize',18)

xlabel('East (m)','FontSize',18)
ylabel('North (m)','FontSize',18)



if printFigure2files
    fh = gcf;
    set(fh, 'Color', [1 1 1])
   
  %  axis equal
  %  set(gca, 'Position', get(gca, 'OuterPosition') - ...
  %      get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    set(gcf, 'PaperUnits', 'inches')
    myPaperSize = get(gcf, 'PaperSize');
    myWidth = 10;
    myHeight = 3.5;
    myLeft = ( myPaperSize(1) - myWidth )/2;
    bottom_ = (myPaperSize(2) - myHeight)/2;
    myFigureSize = [myLeft, bottom_, myWidth, myHeight];
    set(gcf, 'PaperSize', [myWidth myHeight])
    set( gcf, 'PaperPositionMode','manual')
   set( gcf, 'PaperPosition', myFigureSize)
    set( gcf, 'renderer', 'painters')
    
    print( gcf, '-dpdf', [trackfile,'.pdf'])
    print( gcf, '-dpng', [trackfile,'.png'])
    print( gcf, '-depsc2', [trackfile,'.eps'])
end