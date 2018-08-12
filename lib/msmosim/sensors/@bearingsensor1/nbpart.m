function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn,varargin )

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

if isempty(this.meanoneorange) || isempty( this.stdoneorange )
    this.calcinvpolarmodel;
end

for i=1:length(Zs)
    
    bearing = Zs(i).bearing;
    
   % ranges = rand(1,numpartnewborn)*(this.rangemax-this.rangemin) + this.rangemin;
       
    oneoverranges = this.meanoneorange + randn(1, numpartnewborn )*this.stdoneorange;
    ranges = 1./abs(oneoverranges);
    ind = find(ranges>this.maxrange);
    ranges(ind) = ranges(ind)/max(ranges(ind))*this.maxrange;
    
    
    bearings = bearing + randn(1,numpartnewborn)*this.stdang;
    
  
    % The measurements are in the SCS, find them in ECS
    losS = [ranges.*cos(bearings); ranges.*sin(bearings); zeros(1,numpartnewborn )];
    targsE = repmat(ploc,1,numpartnewborn)...
        + R_BE'*(R_SB'*losS + repmat(sloc,1,numpartnewborn) );
    
    nbstates_(:,(i-1)*numpartnewborn+1:i*numpartnewborn ) = targsE([1,2],:); 
    labels( (i-1)*numpartnewborn+1:i*numpartnewborn ) = i;
end

if nargout>1
    varargout{1} = labels;
end
