function [pix, labels] =  assoc2pix( this, particles, pstate, sstate )
% This function associates the 


if isa( particles , 'particle' )
    state_ = particles.catstates;
elseif isa( particles, 'particles' )
    state_ = particles.getstates;
elseif isa( particles, 'numeric')
    state_ = particles;
end

numParticles = size( state_,2);
locationE_ = [ state_([1,2],:); zeros(1,numParticles) ];


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

pix = findpixels(this, bearings, ranges);
labels = pix(:,1) + (pix(:,2)-1)*this.numrows;