function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn, varargin )


reg = [0,0]';
if ~isempty(varargin)
    reg = varargin{1}([1,2],:);
    reg = reg(:);
end

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
    
    ploc = pstate.location + [reg;0];
    sloc = sstate.location;
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = [0 0 0]';
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
    
    ploc = pstate.location*0  + [reg;0];
    sloc = sstate.location*0;
end

nbstates_ = zeros(2,length(Zs)*numpartnewborn );
labels = zeros(1, length(Zs)*numpartnewborn );
for i=1:length(Zs)
    
    range = Zs(i).range;
    bearing = Zs(i).bearing;
    
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
