datfilename = 'simdata_linear_singletarget4pmrf.mat';
save2avi = 0;
filter_in_SCS = 0; % Filter sensor histories in sensor centric coordinate system

mydatafile = datfilename;
load(mydatafile);

% Take the sensors and their locations in earth coordinate system
[sensors, loc] = sim.getsensors;
% Ground truth for the unknowns
Thetas = loc;

% 2) filter the sensor buffers
% a) Make sure that filtering of sensor buffers will be in the sensor frame
for i=1:length(sensors)
    sensori = sensors{i};
    sensori.insensorframe = 1;
    sensors{i} = sensori;
end

deltat = 1;
filtercfg = kfcfg;
filtercfg.veldist = cpdf( gk( [15^2 0;0 15^2], [0 0]') );

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
        0 deltat^3/3 0 deltat^2/2;...
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];

filtercfg.targetmodelcfg = modelcfg;
% c) initiate filters
filters{1} = kf(filtercfg);
for i=2:length(sensors)
    filters{i} = kf(filtercfg);
end

sensrtind = 2;
loc = [ ];
for i=1:9
    mysensor =  sim.platforms{sensrtind + i - 1}.sensors{1};
    mysensor.insensorframe = filter_in_SCS;
    % mysensor.remclutter;
               
    
    sensors{i} = mysensor;    
    loc([1,2], i ) =  sim.platforms{sensrtind + i - 1}.state([1,2]);
end
locSCS = loc;

axisHandles = filters{1}.getaxis('all');

numsteps = length( sensors{1}.srbuffer );
for sennum=1:9
    
    filteri = filters{ sennum };
    sensori = sensors{ sennum };
    
    Xhs = {};
    strt = 1;
    for stepcnt = strt:numsteps
        fprintf('starting step %d,',stepcnt);
        fprintf('\n')
        % do the filtering
        filteri.Z = sensori.srbuffer( stepcnt );
        filteri.onestep( sensori );
       
        Xh = filteri.post.m;
        Xhs{stepcnt} = Xh;
        
        filteri.displaybuffers('axis',axisHandles([1,3,4,6]),'precommands','cla;','postcommands','axis([-2000,2000,-2000,2000]);ylabel(''y'')','clusters','legend'); pause(0.001);
        filteri.displaybuffers('axis',[axisHandles(2),0,axisHandles(5),0],'dims',[3,4]','precommands','cla;','postcommands','axis([-100,100,-100,100]);ylabel(''y'')','clusters','legend'); pause(0.001);
        
        if sensori.insensorframe == 1
            Xt_ = sensori.ecs2scs( Xt{stepcnt} );
        else
            Xt_ = Xt{stepcnt};
        end
        
        plotset( Xt_, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2,''Marker'',''o''','shift',12 );
        plotset( Xt_, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[1 0 0],''Markersize'',8,''Linewidth'',2,''Marker'',''o''','shift',12 );
        
        plotset( Xh, 'dims', [1 2],'axis', axisHandles(4), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2','shift',10 );
        plotset( Xh, 'dims', [3 4],'axis', axisHandles(5), 'options', '''Color'',[0 1 1],''Markersize'',8,''Linewidth'',2' ,'shift', 10);
        
    end
    
    filters{sennum} = filteri;
    
    % Find the estimation performance
    ed1 = [];
    ed2 = [];
    eds = [];
    
    if sensori.insensorframe == 0
        for k=1:length(Xt(strt:numsteps))
            % Find the error norm over the position fields of the state vector
            Xt_ = Xt{k}([1,2],:);
            Xh_ = Xhs{k}([1,2],:);
            
            ed1(k) = norm(Xt_-Xh_);
            % Find the error norm over the velocity fields
            ed2(k) = norm(Xt{k}([3,4],:) - Xhs{k}([3,4],:)  );
            eds(k) = norm( sensori.srbuffer(k).getxy - Xt_);
        end
    else
         for k=1:length(Xt(strt:numsteps))
            % Find the error norm over the position fields of the state vector
            XhE = sensori.scs2ecs( Xhs{k}([1,2,3,4],:) );
            Xt_ = Xt{k}([1,2],:);
            Xh_ = XhE([1,2],:);
            
            ed1(k) = norm(Xt_- Xh_);
            % Find the error norm over the velocity fields
            ed2(k) = norm(XhE([3,4],:) - Xt{k}([3,4],:)  );
            eds(k) = norm( sensori.srbuffer(k).getxy - Xt_);
        end
        
    end
    
    if sennum == 1;
        ofhandle = figure;
        rgbobj = rgb; 
    else
        figure(ofhandle) 
    end
    col = rgbobj.getcoln(10+sennum);
        
    subplot(311)
    hold on
    grid on
    plot(ed1,'Color',col )
    xlabel('RSE error (position)')
    
    subplot(312)
    hold on
    grid on
    plot(ed2,'Color',col )
    xlabel('RSE error (velocity)')
    
    
    subplot(313)
    hold on
    grid on
    plot(eds,'Color',col)
    xlabel('Observation error (in Earth Coord. Sys.')
    
    
    drawnow;
    
end