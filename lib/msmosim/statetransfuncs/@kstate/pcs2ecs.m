function cE = pcs2ecs( p , cp )
% Parent coordinate system to cp

cE = kstate; % Child in Earth Coordinate System (ECS)

xpE = p.location; % location of parent in ECS
angBE = p.orientation; % orientation 
vE = p.velearth;

R_be = dcm( angBE ); % Earth to body transformation


angCB = cp.orientation;
R_cb = dcm( angCB );

angCE = idcm( R_cb*R_be ); % orientation of the Earth to Child trans.

xcE = xpE + R_be'*cp.location ;% location of child in ECS
vCE = vE + R_be'*cp.velocity; % velocity of child in ECS

cE.orientation = angCE;
cE.location = xcE;
cE = cE.setvelearth( vCE );
cE.catstate;

