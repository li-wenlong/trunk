function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn )

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

nbstates_ = zeros(2,length(Zs)*numpartnewborn );
labels = zeros(1, length(Zs)*numpartnewborn );
for i=1:length(Zs)
    
    range = Zs(i).range;
    bearing = Zs(i).bearing;
    
    this.stdang = min( Zs(i).bearingext*pi/180, this.stdang);
    this.stdrange = min( Zs(i).rangext, this.stdrange );
    
    ranges = range + randn(1,numpartnewborn)*this.stdrange;
    bearings = bearing + randn(1,numpartnewborn)*this.stdang;
    
    % The measurements are in the SCS, find them in ECS
    losS = [ranges.*cos(bearings); ranges.*sin(bearings); zeros(1,numpartnewborn )];
     targsE = repmat(plocE,1,numpartnewborn)...
        + R_BE'*(R_SB'*losS + repmat(slocB,1,numpartnewborn) );
    
    nbstates_(:,(i-1)*numpartnewborn+1:i*numpartnewborn ) = targsE([1,2],:); 
    labels( (i-1)*numpartnewborn+1:i*numpartnewborn ) = i;
end

if nargout>1
    varargout{1} = labels;
end
