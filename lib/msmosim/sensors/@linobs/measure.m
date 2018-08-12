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

% Construct the state of the sensor in Body coordinates
sstate = kstate;
sstate.setstatelabels({'x','y','z','psi','theta','phi'});
sstate.substate([this.location;this.orientation]);
sstate.setvelearth( this.velearth );

% Get the state of the sensor in Earth coordinates
sstateE = pcs2ecs( pstate, sstate );

% 
% plocE = pstate.getstate({'x','y','z'});
% angBE = pstate.getstate({'psi','theta','phi'});
% R_BE = dcm(angBE);
% 
% slocB = sstate.getstate({'x','y','z'});
% angSB = sstate.getstate({'psi','theta','phi'});
% R_SB = dcm( angSB );
% 
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
    srcstateE = kstate;
    srcstateE.setstatelabels({'x','y','z','psi','theta','phi'});
    srcstateE.substate([this.srcbuffer.src{i}.location;this.srcbuffer.src{i}.orientation]);
    srcstateE.setvelocity( [this.srcbuffer.src{i}.velocity] );
    
    srcstateS = srce2srcsens( srcstateE, sstateE  );  
    
    srcstateS.setstatelabels( this.statelabels );
    x = srcstateS.catstate;
    z = this.linTrans*x + sqrtm(this.noiseCov)*randn(size(x));
    if sum( abs(imag(z) ))>eps
        warning(sprintf('Possibly non-square rootable noise covariance matrix'));
    end
  
    
    z_ = linmeas;
    z_.Z = z;
   
 
    Z = [Z,  z_ ];
    
end

 %% Code to add the clutter here
aa = cell( length(this.statelabels) ,1);
for i=1:length(aa) 
    aa{i} = this.maxrange*2;
end
[cout]  = this.clutter.getclutter( aa{:}  );
for i=1:length(cout)
    cout{i} = cout{i} - this.maxrange;
end

if ~isempty(cout)
    ax1 = cout{1};
    c = [];
    for i = 1:length(ax1)
        c = ax1(i);
        for j = 2: length( cout )
            c = [c; cout{j}(i)];
        end
        z_ = linmeas;
        z_.Z = c;
        
        
        Z = [Z,  z_];
        given = [given,0];
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
