function varargout = nbcomp( this, sensors, varargin )

isquit = 1;

% Check whether all the sensors have a non-zero number of measurements to 
% create components around,

numMeas = zeros(1,length(sensors));
for i=1:length(this.Z)
    numMeas( i ) = length( this.Z(i).Z );
    if numMeas( i ) ~= 0
        isquit = 0;
    end
end

if isquit
    this.nbintensity = [];
end

if isa( this.Z(1).Z,'mlinmeas' )
    if length(this.Z(1).Z)==1
        if isempty(this.Z(1).Z.Z)
            isquit = 1;
            this.nbintensity = [];
        end
    end
end


if isquit
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end

if nargin>=3
    regs = varargin{1};
end

% take the weights of the velocity distribution of it is a gmm
% otherwise, it is a single gaussian component with weight 1
if isa( this.veldist, 'gmm')
    ws_ = this.veldist.w;
else
    ws_ = 1;
end

totNumMeas = sum( numMeas );
labels = zeros( totNumMeas, 1);
ws = [];
nbcomps = [];


for i = 1:length(sensors)
    sensor = sensors(i);
    
    [ gk1 ] = sensor.mlstate( this.Z(i) ); % Use the ML estimate of the first sensor (i.e. the measurement in the reference coordinate frame)
 
    if i>=2 % align other sensors with respect to the first sensor's coordinate system preference
        for zcnt = 1:length( gk1 )
            gk1(zcnt).m([1,2]) = gk1(zcnt).m([1,2]) + regs([1,2],i-1);
        end
    end
    
    for zcnt = 1:length( gk1 )    
        % Append the velocity model
        nbcomps = [ nbcomps, cpdf( mdiag( gk1(zcnt), this.veldist ) ) ];
        ws = [ws, ws_];
        labels(zcnt) = zcnt + (i-1)*numMeas(i);
    end
 
end

% Hacking now
this.nbintensity = phd;
this.nbintensity.mu = this.probbirth;
this.nbintensity.s.gmm = gmm( ws, nbcomps);


%nbparticles = nbparticles.subweights( this.probbirth/length(nbparticles)*ones(1, length( nbparticles ) )  );
%nbparticles = nbparticles.sublabels({'nb'});

%this.postintensity = nbparticles;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
