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
losP = [];
for i=1:length(this.srcbuffer.src)
    
 if ~this.srcbuffer.src{i}.detwone
        %   % Roll the dice to detect the source
        u = rand; if u>this.pd; continue; end;
    end 
   
   
    % Sources received in the ECS ; find them in the SCS
    losE = this.srcbuffer.src{i}.location - (pstate.location + R_BE'*sstate.location);
    losS = R_SB*R_BE*losE;

    % Find the Los in polar coordinates
    [th,ran,alt] = cart2pol( losS(1), losS(2), losS(3) );
    bearing = atan2( losS(2), losS(1) );
    
    if bearing>=this.alpha | bearing<=-this.alpha
        % Out of range
        continue;
    end
    
    bearing = bearing + this.stdang*randn;
    
   
     
    z = bearingmeas;
  
    z.bearing = bearing;
    %% Code to add noise
    given = [given,this.srcbuffer.src{i}.ID];
    Z = [Z, z];
    losP = [losP,[th,ran]'];
end

if this.detonlynear
   % Check the bearing angles and if there is any one within -+ 1 stdang
   % of another with a higher range, prune it.
   sel = prunefar(losP, this.stdang);
   Z = Z(:,sel);
   given = given( sel );
end

 %% Code to add the clutter here
if isa( this.clutter, 'poisclut1' )
    [cout]  = this.clutter.getclutter( pi*2 );
    if ~isempty(cout)
        cbearing = cout{1};
        

        c = bearingmeas;
        for j=1:length(cbearing)
            c.bearing = cbearing(j) - pi;
   
            Z = [Z, c];
            given = [given,0];
        end
    end
else
    [cout]  = this.clutter.getclutter( this.alpha*2 );
    if ~isempty(cout)
        cbearing = cout{1};
      
        c = bearingmeas;
        for j=1:length(cbearing)
            c.bearing = cbearing(j) - this.alpha;
   
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
