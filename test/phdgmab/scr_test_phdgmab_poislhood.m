
save2avi = 0;
save2fig = 0;

timestamp = num2str(now);
% %  Load the initial conditions
% % 
%load( 'simdata_linear_multitarget1.mat');
load( 'simdata_linear_multitarget4pmrf.mat');
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gridcellwidth = 500;


[initgrid_x,initgrid_y] = meshgrid([-1500:gridcellwidth:1500],...
    [-1500:gridcellwidth:1500]);
initgrid_pts = [initgrid_x(:),initgrid_y(:)]';

numsamples = prod(size(initgrid_x));
numgridpoints = numsamples;


%%%%%%%%%%%%%%%%%%%%%%%%%%
fhandle = figure;
set( fhandle, 'doublebuffer', 'on' );
set( fhandle, 'Color', [1 1 1] );
screenSize = get( get( fhandle, 'Parent'), 'ScreenSize' );
height2Width = screenSize(4)/screenSize(3);
height2WidthReal = screenSize(4)/screenSize(3);

width = 0.9*2/3;
height = 0.3/height2WidthReal;

figurePosition = [0.2 0.3 width height];
realFigurePosition = round( [screenSize(3) screenSize(4) screenSize(3) screenSize(4)].*figurePosition ) ;
set( fhandle, 'Position', realFigurePosition );
ahandle_scenario = subplot(121);
ahandle_particles = subplot(122);

 if save2avi == 1
    avifileName = [['dualtermlhood_test',timestamp],'.avi'];
    aviobj = avifile(avifileName, 'fps', 4, 'keyframe', 1,'quality',100,'videoname','Data Set 1','compression','None');
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Take the sensors and their locations in earth coordinate system
[sensors, loc] = sim.getsensors;
locSCS = loc;
for i=1:length(sensors)
    sensori = sensors{i};
    sensori.insensorframe = 1;
    %sensori.gate;
    %sensori.remsourceid([104000101]);
    %sensori.remclutter;
    sensors{i} = sensori;
end

node1 = 1;
node2 = 2;

sensor1 = sensors{node1};
sensor2 = sensors{node2};


E = {[1,2],[2,1]};
% Configure the filters
% %%%%%%%%%%%%%%%%%%%%%
deltat = 1;
filtercfg = phdgmabcfg;
filtercfg.veldist = cpdf( gk( [15^2 0;0 15^2], [ 0 0]') );
% filtercfg.initstate = cpdf( gk( diag( [15^2, 15^2, 15^2, 15^2] ) , [0 500 10 0]' ) );


modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 0.1*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... plot( ospacombf1, 'k' )
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;


% Initialise the filters
filter1 = phdgmab(filtercfg) ;
filter2 = phdgmab(filtercfg) ;
filters = {filter1, filter2};
sensors = {sensor1,sensor2};

% Filter the sensor buffers, call the function in verbose mode
[localposteriors_, logq2js] = fun_filtersens( sensors, filters , 1 );


T = 20;
winlength= 10;

Ts = [T-winlength+1:T];
timewindow = Ts;

localposteriors = localposteriors_( Ts,:);
prevposteriors = localposteriors_( Ts-1,:);


% for stepcnt = Ts(1):Ts(end)
%     scr_displayscenario;
%     drawnow;
%     
%     if save2avi ==1
%         aviFrame = getframe(gcf);
%         aviobj = addframe(aviobj,aviFrame);
%     end
% end
   

lhoods = zeros(numsamples,winlength,2);
loglhood = zeros(numsamples,winlength,2); 
 
  
%initgrid_pts = [-1000,0]';
%numsamples = 1;
Thetas = {initgrid_pts,-initgrid_pts};


for ecnt = 1:length(E)
    nodei = E{ecnt}(1);
    nodej = E{ecnt}(2);
    
    theta_ij  = Thetas{ecnt};
    
    filteri = filters{nodei};
    filterj = filters{nodej};
    
    sensori = sensors{nodei};
    sensorj = sensors{nodej};
    
    for k=1:numsamples
        
        lhoodcontr = zeros(length( timewindow ),1);
        loglhoodcontr = zeros(length( timewindow ),1);
        for tcnt = 1:length( timewindow )
            
            stepcnt = timewindow(tcnt);
            
            trmod = prevposteriors{ tcnt ,nodej}; % This is the local posterior transmitted in the previous step
            
            localposterior = localposteriors{ tcnt ,nodei};
            
            locpred = prevposteriors{ tcnt ,nodei};
            locpredpar = locpred.s.particles;
            locpredpar = filteri.targetmodel.transtates( locpredpar );
            locpred.s.particles = locpredpar;
            
            
            filteri.Z = sensori.srbuffer( stepcnt ); % This is a bit of a hack
            filterj.Z = sensorj.srbuffer( stepcnt );
            
            trconf = trmod;
            
            % First apply the \tau o \tau^-1 ( . ; \theta_i,
            % theta_j) and convert the particles into those in the
            % ith coordinate frame
            trconfgmm = trconf.s.gmm;
            trconf.s.gmm = rotrans( trconfgmm, 'alpha', 0, 'translate', [ theta_ij(1,k), theta_ij(2,k) 0 0]' );
            
%             if ~exist('fhandle2')
%                 fhandle2 = figure;
%             end
%             figure(fhandle2)
%             clf;
%             trconfgmm.draw('axis',gca,'options','''Color'',[1 0 0],''linestyle'',''-.''')
%             trconf.s.gmm.draw('axis',gca,'options','''Color'',[1 0 0],''linestyle'',''-.''')
            
            %
            
            % Second, go with the Markov shift and obtain the
            % corresponding prediction density
            trconf.s.gmm = filteri.targetmodel.transtates( trconf.s.gmm );
            
           
            [lhoods(k,tcnt,ecnt), loglhood(k,tcnt,ecnt)]  = filteri.parlhoodpois( trconf, sensori ); % with the current observations
        end
        
    end
end


logs_ij = squeeze( loglhood(:,:,1) );
logs_ji = squeeze( loglhood(:,:,2) );

loglhood1 = sum( logs_ij,2  );
loglhood2 = sum( logs_ji,2  );

loglhood1_mesh = reshape( loglhood1, size(initgrid_x) );
loglhood2_mesh = reshape( loglhood2, size(initgrid_x) );

sloglhood = loglhood1 + loglhood2;
sloglhood_mesh = reshape( sloglhood, size(initgrid_x) );

figure
grid on
hold on
plot3( initgrid_pts(1,:), initgrid_pts(2,:), sloglhood, '.' )
xlabel('x')
ylabel('y')
title('log dual term')

figure
subplot(221)
surf( initgrid_x',initgrid_y', loglhood1_mesh' )
xlabel('x')
ylabel('y')
subplot(222)
surf( initgrid_x',initgrid_y', loglhood2_mesh' )
xlabel('x')
ylabel('y')

subplot(224)
surf( initgrid_x',initgrid_y', sloglhood_mesh' )
xlabel('x')
ylabel('y')

% Take the exponential of log lhood terms to find the actual dual term
% values
dualterms = log2norm( {sloglhood} );
dualterms_mesh = reshape(dualterms{1}, size(initgrid_x) );

figure
grid on
hold on
surf( initgrid_x',initgrid_y', dualterms_mesh' )
xlabel('x')
ylabel('y')
title('dual term')

