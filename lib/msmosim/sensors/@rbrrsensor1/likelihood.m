function G = likelihood( this, obs, particles )


%% Hacking this time
Zs = obs.Z;
if isa( particles , 'particle' )
    numParticles = length(particles);
elseif isa( particles, 'particles' )
    numParticles = particles.numparticles;
elseif isa( particles, 'numeric' )
    numParticles = size( particles, 2 );
end

G = zeros( length(Zs), numParticles );

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
velE_ = [ state_([3,4],:); zeros(1,numParticles) ];

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
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
end
 
for i=1:length(Zs)
    
    range = Zs(i).range;
    bearing = Zs(i).bearing;
    rangerate = Zs(i).rangerate;
    
    % Sources received in the ECS ; find them in the SCS
    
    losE = locationE_ - repmat( (pstate.location + R_BE'*sstate.location),1, numParticles );
    losS = R_SB*R_BE*losE;
    ranges = sqrt( sum( losS.*losS,1 ) );
    bearings = atan2( losS(2,:), losS(1,:) );
    
    velE = velE_ - repmat( (pstate.velearth + R_BE'*sstate.velocity),1, numParticles );
    velS = R_SB*R_BE*velE;
    
    losSnorms = sqrt( sum( losS.^2,1) );
    losSuv = losS./repmat( losSnorms ,3,1 );
    
    rangerates = sum( losSuv.*velS, 1 );
    
    %
    nranges = range - ranges;
    nbearings = bearing - bearings;
    nrangerate = rangerate - rangerates;
 
    
    G(i,:) = ( (1/(this.stdang*sqrt(2*pi) ) )*exp( -( ( nbearings/this.stdang ).^2)/2  ) ).*...
       ( (1/(this.stdrange*sqrt(2*pi) ) )*exp( - (( nranges/this.stdrange ).^2)/2  ) ).*...
       ( (1/(this.stdrangerate*sqrt(2*pi) ) )*exp( - (( nrangerate/this.stdrangerate ).^2)/2  ) );
   
   %G(i,:) = ( (1/(this.stdang*sqrt(2*pi) ) )*exp( -( ( nbearings/this.stdang ).^2)/2  ) ).*...
    %   ( (1/(this.stdrange*sqrt(2*pi) ) )*exp( - (( nranges/this.stdrange ).^2)/2  ) );
    
end

