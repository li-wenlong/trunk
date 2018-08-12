% This script invokes the constructor and init method of the
% Platform class platform

deltat = 0.1;
pcfg = platformcfg;
pcfg.statelabels = {'x','y','vx','vy'};
pcfg.state = [0 1500 200 0]';

pcfg.stfswitch = [10,50,90,120,150];
pcfg.stfs = {'lingauss','circmotion','lingauss','identity','die'};


lingausscfg = stf_lingausscfg;
lingausscfg.deltat = 0.1;
lingausscfg.F = ...
   [1 0 1*deltat 0;...
    0 1 0 1*deltat;...
    0 0 1 0;...
    0 0 0 1];
lingausscfg.Q = ...
    [    1 0 0 0;...
         0 1 0 0;...
         0 0 1*deltat 0;...
         0 0 0 1*deltat];

pcfg.stfcfgs{1} = lingausscfg;

circmotioncfg = stf_circmotioncfg;
circmotioncfg.centre = [8000,0,0]';

pcfg.stfcfgs{2} = circmotioncfg;
pcfg.stfcfgs{3} = lingausscfg;


identitycfg = stf_identitycfg;
identitycfg.deltat = 1;

pcfg.stfcfgs{4} = identitycfg;

diecfg = stf_diecfg;
diecfg.deltat = 1;

pcfg.stfcfgs{5} = diecfg;

plat = platform( pcfg );

