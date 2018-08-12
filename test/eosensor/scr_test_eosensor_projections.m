% Configure an eosensor object

sensorcfg1 = eosensorcfg; % Get the config
pdprofilecfg = sensorcfg1.pdprofilecfg;
pdprofilecfg.pdatzero = 1.0;
pdprofilecfg.pdfar = 0.9;
pdprofilecfg.range = 10000;
pdprofilecfg.threshold = 4000;
sensorcfg1.pdprofilecfg = pdprofilecfg;

sensorcfg1.F = 0.008;
sensorcfg1.S2 = 0.008;
sensorcfg1.numrows = 576;
sensorcfg1.numcols = 768;
sensorcfg1.ipwidth = ( tan(20.5*pi/180) )*2*sensorcfg1.S2; % 0.036/2;
sensorcfg1.ipheight = ( sensorcfg1.ipwidth /1.33333 );

senorientation = sensorcfg1.orientation;
senorientation(1) = -pi/4;
senorientation(2) = 5*pi/180;
senorientation(3) = 5*pi/180;
sensorcfg1.orientation = senorientation;
% sensorcfg1.detonlynear = 1;

clutcfg = eobinomclutcfg;
clutcfg.p = 10/( sensorcfg1.numrows * sensorcfg1.numcols);


sensorcfg1.cluttercfg = clutcfg;

eosensorobj = eosensor( sensorcfg1 );
platformID = 100100222;
eosensorobj.setID( platformID );

pstate = kstate;
pstate.setstatelabels({'psi','theta','phi'});
pstate.substate( [ pi, 0, 0 ]' );
pstate.catstate;

eosensorobj.drawfrustum(pstate);

senorientation = sensorcfg1.orientation;
senorientation(1) = 0;
senorientation(2) = 0;
senorientation(3) = 0;
sensorcfg1.orientation = senorientation;
eosensorobj2 = eosensor( sensorcfg1 );
platformID = 100100222;
eosensorobj2.setID( platformID );
aHandle = gca;
eosensorobj2.drawfrustum(pstate,'axis',aHandle,'options', {'''Color'',[1 0 0]'});
xlabel('x')
ylabel('y')
zlabel('z')


srbuffer(1:sensorcfg1.numcols) = sreport;
 for i=1:length(srbuffer)
     
     
     Z = srbuffer(i);
     zz = pixmeas;
     
     % Note that these are they appear on the image plane at x = -F which
     % is and upside-down and left-right flipped version of what we see on
     % the screen
     zz.row = 1 + mod( i-1, sensorcfg1.numrows );
     zz.col = i; % 
     
     Z.Z = zz;
     
     srbuffer(i) = Z;
 end
eosensorobj.adaptsrbuffer( srbuffer, 'pstate', pstate );

eosensorobj.drawsrbuffer;
rgbobj= rgb;

for i=1:length( srbuffer )
    eosensorobj.draw('axis', aHandle,'timestep',i,'options',{['''Color'',[',num2str( rgbobj.getcol ),']']});
    drawnow;
end

sstate = kstate;
sstate.substate( eosensorobj.location, {'x','y','z'});
sstate.substate( eosensorobj.orientation, {'psi','theta','phi'});
sstate.setvelearth( eosensorobj.velearth );
sstate.catstate;

sensorE = pcs2ecs( pstate , sstate );
hold on;plot3( sensorE.location(1), sensorE.location(2), sensorE.location(3), 's','Markersize', 12 )