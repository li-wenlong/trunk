function varargout = setstate( this, state_, time )

if ~isa(time, 'numeric' ) || length(time)~=1
    error('The time stamp is a scalar!');
end
if ~isa( state_, kstate )
    error('The state should be contained in a kstate object!')
end

time = time(1);

% crrnttime = this.stfobjs{ this.crrntstfnum }.gettime;
% 
% 
%  % Have the state transition function of the platform proceed
% prseq = sseq( this.stfswitch, crrnttime, time );
% 
% % Run the state transition
% this.stfobjs{ this.crrntstfnum } = this.stfobjs{ this.crrntstfnum }.proceed2time( prseq(1) );
% 
% for i=2:length(prseq)
%    % Get the full state from the previous
%    ks = this.stfobjs{this.crrntstfnum}.getkstate;
%    % Set the full state for the current
%    this.stfobjs{this.crrntstfnum+1} = this.stfobjs{this.crrntstfnum+1}.setkstate( ks );
%    % Get the time from the previous
%    
%    % For convenience we comment out the line below
%    % lasttime = this.stfobjs{this.crrntstfnum}.gettime;
%    % and rather use this:
%    lasttime =  prseq(1) ;
%    % Set the time of the current stf
%    this.stfobjs{this.crrntstfnum + 1} = this.stfobjs{this.crrntstfnum + 1}.settime(lasttime);
%    
%    % Increase the stf pointer
%    this.crrntstfnum = this.crrntstfnum + 1;
%    if prseq(i)-prseq(i-1)>eps
%    % Proceed with the current state transition function
%    this.stfobjs{ this.crrntstfnum } = this.stfobjs{ this.crrntstfnum }.proceed2time( prseq(i) );
%    end
% end

this.state = state_;
%% Add the current state to the track buffer
cs = this.getkstate; % Current state
tr = treport; % Get track report
tr.state = cs;
tr.time = time;

this.track.treps = [this.track.treps, tr];

%% Have the sources proceed
for i=1:length( this.sources )
   this.sources{i}  = this.sources{i}.proceed2time(  time, cs );
end
%% Have the sensors proceed
for i=1:length( this.sensors )
   this.sensors{i}  = this.sensors{i}.proceed2time(  time, cs );
end



% Return the resultant object
if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
