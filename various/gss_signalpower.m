function  int_E = gss_signalpower( sensorObj, filterObj, int_E, numiter )

steps = [15:30];
for iternum=1:numiter
% Now go on with the betasquare dimension and perform golden ratio
    % search
    
    x = int_E(2) - 0.618*( int_E(2) - int_E(1) );
    y = int_E(1) + 0.618*( int_E(2) - int_E(1) );
    
    disp( sprintf('Interval of E [a,b] and x and y:%g, %g, %g, %g', int_E(1), int_E(2), x, y) );
    
    sensorObj.signalpower = x;
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    
    f_x = sum(sploglhoods(steps))/length(steps);
    
    sensorObj.signalpower = y;
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    
     f_y = sum(sploglhoods(steps))/length(steps);
    
    disp( sprintf('f_x and f_y:%g', f_x, f_y) );
    
    if f_x>f_y % converted to greater than to maximise
       int_E(2) = y;
       y = x;
       x = int_E(2) - 0.618*( int_E(2) - int_E(1) );
    else
        int_E(1) = x;
        x = y;
        y = int_E(1) + 0.618*( int_E(2) - int_E(1) );      
    end
end
