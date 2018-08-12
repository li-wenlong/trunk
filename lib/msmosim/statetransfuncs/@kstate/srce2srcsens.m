function  srcstateS = srce2srcsens( srcstateE, sstateE  )

srcstateS = kstate;

R_srcE = dcm( srcstateE.orientation );
R_senE = dcm( sstateE.orientation );

losE = srcstateE.location - sstateE.location;
losS = R_senE*losE;
srcstateS.location = losS;


angsrcsen = idcm( R_srcE*R_senE'  );
srcstateS.orientation = angsrcsen;

velearthdiff = srcstateE.velearth - sstateE.velearth;
velS = R_senE*velearthdiff;

% Note that here earth refers to sensor
srcstateS.setvelearth( velS );

accelS = srcstateE.accelearth - sstateE.accelearth; 
srcstateS.setaccelearth( accelS );

srcstateS.catstate;
