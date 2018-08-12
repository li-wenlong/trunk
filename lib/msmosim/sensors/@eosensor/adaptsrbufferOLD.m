function varargout = adaptsrbuffer(this, srbuffer, varargin )

timestamp = this.time;


ispstate = 0;
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'pstate' )
            ispstate = 1;
            pstate =  varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

sstate = kstate;
sstate.setstatelabels({'x','y','z','psi','theta','phi'});
sstate.substate([this.location;this.orientation]);
sstate.setvelearth( this.velearth );
        
for i=1:length( srbuffer )
    sr = srbuffer(i);
    if ispstate
        sr.pstate = pstate;
    end
    sr.sstate = sstate;
    
    srbuffer(i) = sr;
end


this.srcbuffer = {};
this.srbuffer = srbuffer;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
