function [sensors, varargout] = getsensors(this)
% This method returns all of the sensors in the simulation object in a cell
% array.
% [s, locE ] = @msmosim.getsensors
% also returns the initial locations of the sensors in earth coordinates
% (i.e., converting the coordinate system chain Earth-->platform-->sensor)
numap = [];
times = [];
sensors = {};
locE = [];
for i=1:length( this.platforms )
    
    if ~isempty( this.platforms{i}.sensors )
        
        psensors = this.platforms{i}.sensors;
        sensors(end+1:end+length(psensors) ) = psensors;
        for j=1:length(psensors)
            locEs = psensors{j}.srbuffer.getstatearth;
            locE([1,2],end+1) = locEs([1,2],1);
        end
    end
end

if nargout>=2
    varargout{1} = locE;
end