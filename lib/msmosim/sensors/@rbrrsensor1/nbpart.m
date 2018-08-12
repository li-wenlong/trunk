function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn, veldistobj )

Zs = obs.Z;

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

nbstates_ = zeros(4,length(Zs)*numpartnewborn );
labels = zeros(1, length(Zs)*numpartnewborn );
for i=1:length(Zs)
    
    range = Zs(i).range;
    bearing = Zs(i).bearing;
    rangerate = Zs(i).rangerate;
    
    ranges = range + randn(1,numpartnewborn)*this.stdrange;
    bearings = bearing + randn(1,numpartnewborn)*this.stdang;
    rangerates = rangerate + randn(1,numpartnewborn)*this.stdrangerate;
    
    % The measurements are in the SCS, find them in ECS
    losS = [ranges.*cos(bearings); ranges.*sin(bearings); zeros(1,numpartnewborn )];
    targsE = repmat(pstate.location,1,numpartnewborn)...
        + R_BE'*(R_SB'*losS + repmat(sstate.location,1,numpartnewborn) );
    
    nbstates_([1,2],(i-1)*numpartnewborn+1:i*numpartnewborn ) = targsE([1,2],:); 
    labels( (i-1)*numpartnewborn+1:i*numpartnewborn ) = i;
    
    % Find the unit vectors in the direction of Los
    losSnorms = sqrt( sum( losS.^2,1) );
    losSuv = losS./repmat( losSnorms ,3,1 );
    
    rrvecS = losSuv.*repmat( rangerates,3,1);
    
    % Consider only the 2-d case
    rrvecS = rrvecS([1,2],:);
    
    % Find vectors orthonormal to the los dirs
    ortvecS = [losSuv(2,:);-losSuv(1,:)];
    
        
    [vels, comps] = gensamples( veldistobj, numpartnewborn );% Take only one direction
    
    % Fint the complementary vectors
    compS = repmat( sum(ortvecS.*vels,1),2,1).*ortvecS;
    
   % compS = ortvecS.*repmat( 20*randn(1, numpartnewborn), 2,1 );
    
    velS = [( rrvecS + compS ); zeros( 1, numpartnewborn ) ];
    
    velE = repmat( pstate.velearth, 1, numpartnewborn )...
        + R_BE'*( R_SB'*velS + repmat(sstate.velocity, 1, numpartnewborn ) );
    velE = velE([1,2],:);
    
    
    nbstates_([3,4],(i-1)*numpartnewborn+1:i*numpartnewborn ) = velE; 
    
    
end

if nargout>1
    varargout{1} = labels;
end

