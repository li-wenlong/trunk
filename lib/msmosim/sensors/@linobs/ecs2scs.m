function pS = ecs2scs(this, pE )

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
    

pS = zeros(size(pE));
for i=1:size(pE,2)
    pnt = pE(:,i);
    % Point in the ECS; find it in the SCS
    losE = [pnt([1,2]);0] - (ploc + R_BE'*sloc);
    velE = [pnt([3,4]);0];

    losS = R_SB*R_BE*losE;
    velS = R_SB*R_BE*velE;
    
    pS(:,i) = [losS([1,2]);velS([1,2])];  
end


