function [E, betasq, zk, I1, I0] = likelihoodgradarrays( this, obs, particles )


%% Hacking this time
Zs = obs.Z;
if isa( particles , 'particle' )
    numParticles = length(particles);
elseif isa( particles, 'particles' )
    numParticles = particles.numparticles;
elseif isa( particles, 'numeric' )
    numParticles = size( particles, 2 );
end

G = zeros( 2, numParticles );

if numParticles == 0
    return;
end

if isa( particles , 'particle' )
    state_ = particles.catstates;
elseif isa( particles, 'particles' )
    state_ = particles.getstates;
elseif isa( particles, 'numeric')
    state_ = particles;
end

locationE_ = [ state_([1,2],:); zeros(1,numParticles) ];

% No observation on the velocity component
% velocityE_ = [ state_([3,4],:); zeros(1,numParticles) ];

pstate = obs.pstate;
sstate = obs.sstate;

if this.insensorframe == 0
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
    
    losE = locationE_ - repmat( (pstate.location + R_BE'*sstate.location),1, numParticles );
    losS = R_SB*R_BE*losE;
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
    
    losE = locationE_;
    losS = losE;  
end
% Sources received in the ECS ; find them in the SCS
[th,ran,alt] = cart2pol( losS(1,:), losS(2,:), losS(3,:) ); % bearing range altitude
ranges = sqrt( sum( losS.*losS,1 ) );
bearings = atan2( losS(2,:), losS(1,:) );
M = ones( length(bearings), 1);

% Check the bearing angles and ranges of the particles, exclude those
% outside the field of view
ind = find( bearings > this.maxalpha ); 
M(ind) = 0;

ind = find( bearings < this.minalpha );
M(ind) = 0;

ind = find( ranges < this.minrange );
M(ind) = 0;

ind = find( ranges > this.maxrange );
M(ind) = 0;
% For the Rician case
% sigma = sqrt( beta^2/2), s = E
pd = makedist('Rician','s',this.signalpower,'sigma', sqrt( this.betasquare/2 ) );

pix_coords = this.findpixels( bearings, ranges );
Zs_ = Zs( pix_coords(:,1) + ( pix_coords(:,2)-1)*this.numrows );

G(1,:) = pdf( pd, Zs_);
% For the rayleigh case
% b = sqrt( beta^2/2)
G(2,:) = raylpdf( Zs_, sqrt( this.betasquare/2 )  );

E = this.signalpower;
betasq = this.betasquare;
zk = Zs_;

I1 = besseli(1, 2*zk*E/betasq );
I0 = besseli(0, 2*zk*E/betasq );


if nargout >=2
    varargout{1} = M;
end

if nargout>=3
    varargout{2} = [bearings;ran];
end

