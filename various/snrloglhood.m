function [loglhoods, sploglhoods, varargout ] =  snrloglhood( sensorObj, filterObj )
% This function is used to estimate the SNR outputs the loglhoods (total) and signal power

numsteps = length( sensorObj.srbuffer );

loglhoods = [];
sploglhoods = [];
delEs = [];
delbetasqs = [];

for stepcnt = 1:numsteps 
       
    filterObj.Z = sensorObj.srbuffer( stepcnt );
    filterObj.onestep( sensorObj );
    loglhoods = [loglhoods, filterObj.parloglhood ];
    sploglhoods = [ sploglhoods, filterObj.sploglhood];
    delEs = [delEs, filterObj.delE];
    delbetasqs = [ delbetasqs, filterObj.delbetasq];
    
end

if nargout>=3
    varargout{1} = delEs;
end
if nargout>=4
    varargout{2} = delbetasqs;
end
    