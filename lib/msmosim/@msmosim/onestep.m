function varargout = onestep(this)



crrnttime = this.time;
proctime  =  crrnttime + this.deltat;

this.findactplats;

% Save the active platforms
info.actplats = this.actplats;
info.time = crrnttime;
this.actplatsbuffer = [this.actplatsbuffer, info ];

% Proceed the active platforms
for i=1:length(this.actplats)
    this.platforms{this.actplats(i)} = this.platforms{this.actplats(i)}.proceed2time( proctime );
end

% Get all sources from the platforms
sourcelist = {};
for i=1:length(this.actplats)
    sourcelist = [sourcelist, this.platforms{this.actplats(i)}.getsources ];
end

% Feed all the sensors with the sources
for i=1:length(this.actplats)
    this.platforms{this.actplats(i)}  = this.platforms{this.actplats(i)}.feedsensors( sourcelist, proctime );
end

% Have all the sensors calculate their observations
for i=1:length(this.actplats)
    this.platforms{this.actplats(i)}  = this.platforms{this.actplats(i)}.trigsensors;
end


% Get the sensor reports

this.time = proctime;



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
