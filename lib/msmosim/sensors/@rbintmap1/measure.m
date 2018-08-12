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

given = zeros(this.numrows,this.numcols);

% For the rayleigh case
% b = sqrt( beta^2/2)
Z = raylrnd( sqrt( this.betasquare/2 ) , this.numrows,this.numcols); % The noise
% For the Rician case
% sigma = sqrt( beta^2/2), s = E
pd = makedist('Rician','s',this.signalpower,'sigma', sqrt( this.betasquare/2 ) );

for i=1:length(this.srcbuffer.src)
    % Sources received in the ECS ; find them in the SCS
    losE = this.srcbuffer.src{i}.location - (pstate.location + R_BE'*sstate.location);
    losS = R_SB*R_BE*losE;

    bearing = atan2( losS(2), losS(1) ); % between -pi and pi
    range = norm( losS );
    
    % Find the if the source is in the FoV
    isinFoV = 0;
    if bearing <= this.maxalpha && bearing  >= this.minalpha
        if range<= this.maxrange && range >= this.minrange
            isinFoV = 1;
        end      
    end
    
    if ~isinFoV
        % Out of range
        continue;
    end
  
%      %pix_col  = min( floor( (bearing - this.minalpha )/(this.deltabearing) ) + 1, this.numcols );
%      pix_col  = min( floor( (-bearing + this.maxalpha )/(this.deltabearing) ) + 1, this.numcols );
%      pix_row  = min( floor( (range - this.minrange)/(this.deltarange) ) + 1, this.numrows );
%     
    pixcoord = this.findpixels ( bearing, range );
    pix_col = pixcoord(2);
    pix_row = pixcoord(1);
   
    given(pix_row,pix_col) = this.srcbuffer.src{i}.ID;
    Z( pix_row,pix_col ) = pd.random;
end

% % Check the sources that raise detections at the same pixel and discard
% % those which are behind another one
% not implemented for now

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
