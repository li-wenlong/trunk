function varargout = measure(this, varargin )

timestamp = this.time;
pstate = kstate;

for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'time' )
            % Time stamp
            if ~isnumeric( varargin{cnt+1} )
                error('The time stamp should be a scalar.');
            end
            timestamp = varargin{cnt+1};
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
        
plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );

sr = sreport;
sr.time = timestamp;
sr.pstate = pstate;
sr.sstate = sstate;

given = [];
Z = [];
for i=1:length(this.srcbuffer.src)
    
 if ~this.srcbuffer.src{i}.detwone
        %   % Roll the dice to detect the source
        u = rand; if u>this.pd; continue; end;
    end  
    given = [given,this.srcbuffer.src{i}.ID];
    
       
    % Sources received in the ECS ; find them in the SCS
    losE = this.srcbuffer.src{i}.location - (pstate.location + R_BE'*sstate.location);
    losS = R_SB*R_BE*losE;
    range = norm( losS ) + this.stdrange*randn;
    bearing = atan2( losS(2), losS(1) ) + this.stdang*randn;
    
    % Find velocity of the source in sensor coordinate system
    velE = this.srcbuffer.src{i}.velearth - (pstate.velearth + R_BE'*sstate.velocity);
    velS = R_SB*R_BE*velE; % This is the xdot ydot zdot we are looking for
    
    rangerate = losS'*velS/norm(losS') + this.stdrangerate*randn;
        
    
    z = rbrrmeas;
  
    z.range = range;
    z.bearing = bearing;
    z.rangerate = rangerate;
    %% Code to add noise
 
    Z = [Z, z];
    
end

 %% Code to add the clutter here
if isa( this.clutter, 'poisclut1' )
    [cout]  = this.clutter.getclutter( pi*2, this.maxrange, this.maxvel*2  );
    if ~isempty(cout)
        cbearing = cout{1};
        crange = cout{2};
        crangerate = cout{3};

        c = rbrrmeas;
        for j=1:length(cbearing)
            c.bearing = cbearing(j) - pi;
            c.range = crange(j);
            c.rangerate = crangerate(j) - this.maxvel;
            Z = [Z, c];
            given = [given,0];
        end
    end
else
    [cout]  = this.clutter.getclutter( this.alpha*2, this.maxrange, this.maxvel*2   );
    if ~isempty(cout)
        cbearing = cout{1};
        crange = cout{2};
        crangerate = cout{3};

        c = rbrrmeas;
        for j=1:length(cbearing)
            c.bearing = cbearing(j) - this.alpha;
            c.range = crange(j);
            c.rangerate = crangerate(j) - this.maxvel ;
            Z = [Z, c];
            given = [given,0];
        end
    end
end

sr.given = given;
sr.Z = Z;


this.srcbuffer = {};
this.srbuffer = [this.srbuffer, sr];


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
