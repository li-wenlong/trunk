function varargout = loadfromlidarfile( this, fname, varargin )


pstate = kstate;

istimeoverload = 0;
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'time' )
            % Time stamp
            if ~isnumeric( varargin{cnt+1} )
                error('The time stamp should be a scalar.');
            end
            timestamps = varargin{cnt+1};
            istimeoverload = 1;
        elseif strcmp( lower( varargin{cnt} ), 'pstate' )
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

% Load chunks;
fcontent = load(fname);
if ~istimeoverload
    datevec_ = datevec( fcontent.chunk(:,1) );
    timestamps = datevec_(:,4) + datevec_(:,5)/60 + datevec_(:,6)/60/60;
end
data = fcontent.chunk(:,2:end);


Z = fun_chunk2mlinmeas(data); % These are all in sensor coordinates;


for i=1:length( timestamps )
    sr = sreport;
    sr.time = timestamps(i);
    sr.pstate = pstate;
    sr.sstate = sstate;
    sr.Z = Z{i};
    sreports(i) = sr;
end

this.srbuffer = sreports;



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end