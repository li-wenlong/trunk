function  int_betasquare = gss_betasquare( sensorObj, filterObj, int_betasquare, numiter )

steps = [15:30];
for iternum=1:numiter
% Now go on with the betasquare dimension and perform golden ratio
    % search
    x = int_betasquare(2) - 0.618*( int_betasquare(2) - int_betasquare(1) );
    y = int_betasquare(1) + 0.618*( int_betasquare(2) - int_betasquare(1) );
    
    disp( sprintf('Interval of betasquare [a,b] and x and y:%g, %g, %g, %g', int_betasquare(1), int_betasquare(2), x, y) );
  
    sensorObj.betasquare = x;
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    
    f_x = sum(loglhoods(steps))/length(steps);
    ll_E1 = sum(sploglhoods(steps))/length(steps);
    
    sensorObj.betasquare = y;
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    
    f_y = sum(loglhoods(steps))/length(steps);
    ll_E2 = sum(sploglhoods(steps))/length(steps);
    
    disp( sprintf('f_x and f_y:%g', f_x, f_y) );
    if f_x>f_y % converted to greater than to maximise
       int_betasquare(2) = y;
       y = x;
       x = int_betasquare(2) - 0.618*( int_betasquare(2) - int_betasquare(1) );
    else
        int_betasquare(1) = x;
        x = y;
        y = int_betasquare(1) + 0.618*( int_betasquare(2) - int_betasquare(1) );
        
    end
end
