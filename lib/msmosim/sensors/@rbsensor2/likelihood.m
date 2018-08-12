function [G, varargout] = likelihood( this, obs, particles )


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
logG = G;
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

% Now check the mask
% 1) w.r.t. \alpha
ind = find( bearings > this.alpha ); 
M(ind) = 0;
% if ~isempty(ind)
%     disp(sprintf('>alpha'));
% end

ind = find( bearings < -this.alpha );
M(ind) = 0;
% if ~isempty(ind)
%     disp(sprintf('<alpha'));
% end




for i=1:length(Zs)
    
    range = Zs(i).range;
    bearing = mapang( Zs(i).bearing );
    
   
    nranges = range - ranges;
    nbearings = bearing - bearings;
 
    logG(i,:) = log(1/(this.stdang*sqrt(2*pi)) )  -( ( nbearings/this.stdang ).^2)/2   +...
     log(1/(this.stdrange*sqrt(2*pi)) ) - (( nranges/this.stdrange ).^2)/2 ;

    G(i,:) = ( (1/(this.stdang*sqrt(2*pi) ) )*exp( -( ( nbearings/this.stdang ).^2)/2  ) ).*...
       ( (1/(this.stdrange*sqrt(2*pi) ) )*exp( - (( nranges/this.stdrange ).^2)/2  ) );
    
end


if nargout >=2
    varargout{1} = M;
end

if nargout>=3
    varargout{2} = [bearings;ran];
end
if nargout>=4
    varargout{3} = logG;
end


