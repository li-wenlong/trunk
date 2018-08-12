addpath( genpath( findir(cd,'workspace') )); % Update the matlab path


load rbrrsensortestdata_1t2s_2.mat


deltat = 1;
filtercfg = cphdmcabcfg;
filtercfg.numpartnewborn = 250; % Number of particles for new target candidates
filtercfg.numpartpersist = 1250; % Number of particles for persistent targets
filtercfg.probbirth = 0.0009;
filtercfg.probsurvive = 0.98;
filtercfg.probdetection = 0.95;

filtercfg.veldist = gmm(1',gk( [15^2 0;0 15^2], [ 0 0]'));

modelcfg = stf_lingausscfg;
modelcfg.deltat = deltat;
modelcfg.statelabels = {'x','y','vx','vy'};
modelcfg.state = [0 0 0 0]';
modelcfg.F = [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
modelcfg.Q = 0*[...
        deltat^3/3 0 deltat^2/2 0;...
        0 deltat^3/3 0 deltat^2/2;... plot( ospacombf1, 'k' )
        deltat^2/2 0 deltat 0;...
         0 deltat^2/2 0 deltat];
     
filtercfg.targetmodelcfg = modelcfg;
     
initcphdfilter = cphdmcab(filtercfg);



if ~exist('isResetDefaultStream')
stream = RandStream.getDefaultStream;
reset(stream);
isResetDefaultStream = 1;
end



% 3-D Eval plot vs. scatter plot
if ~exist('displayon')
    displayon = 1;
end
if ~exist('scatterploton')
    scatterploton = 1;
    displayon = 0;
end
if scatterploton
    displayon = 0;
end
if displayon
    scatterploton= 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%


for mctrial = 1:100
    fprintf('Running trial %d,', mctrial );
    sim = msmosim(simcfg);
    sim.run;
    
    sensorObj  =  sim.platforms{2}.sensors{1};
    sensorObj2  =  sim.platforms{3}.sensors{1};
    % Use onestep
    numsteps = length( sensorObj.srbuffer );

    filterObj  = initcphdfilter;
    filterObj2  = initcphdfilter;
    
    
    
    Xhs = {};
    Xhs2 = {};
    
    disp(sprintf('Filtering the buffer of length %d :', numsteps));
    for stepcnt = 1:numsteps
        filterObj.Z = sensorObj.srbuffer( stepcnt );
        filterObj.onestep( sensorObj );
        Xh = filterObj.mosestodc;
        
        filterObj2.Z = sensorObj2.srbuffer( stepcnt );
        filterObj2.onestep( sensorObj2 );
        Xh2 = filterObj2.mosestodc;
        
        
        Xhs = [Xhs, {Xh}];
        Xhs2 = [Xhs2, {Xh2}];
        
        fprintf('%d,',stepcnt);
        if mod(stepcnt,20)==0
            fprintf('\n');
        end
        
    end
      
    save(['mctry',num2str(mctrial),'.mat' ],'Xhs','Xhs2');
end








