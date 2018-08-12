function pE = scs2ecs(this, pS )

pstate = this.srbuffer(end).pstate;
sstate = this.srbuffer(end).sstate;

plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );

ploc = pstate.location;
sloc = sstate.location;
    

pE = zeros(size(pS));
for i=1:size(pS,2)
    pnt = pS(:,i);
    % Point in the SCS; find it in the ECS
    losB = R_SB'*[pnt([1,2]);0]; % this is in body coordinate system
    losB = losB + sloc ; % Shift the origin
    losE = R_BE'*losB + ploc;
    
    velS = [pnt([3,4]);0];
    velE = (R_SB*R_BE)'*velS;
    
    pE(:,i) = [losE([1,2]);velE([1,2])];  
end


