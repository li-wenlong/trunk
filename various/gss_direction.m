function  [int_lambda, param_est] = gss_direction( sensorObj, filterObj, init_param, d, int_lambda, numiter, steps )
% Golden ratio line search along the direction d from init_param to
% maximise the log likelihood
% 
for iternum=1:numiter
    % Now go on along the direction d and perform golden ratio
    % search
    x = int_lambda(2) - 0.618*( int_lambda(2) - int_lambda(1) );
    y = int_lambda(1) + 0.618*( int_lambda(2) - int_lambda(1) );
    
    disp( sprintf('Interval of lambda [a,b] and x and y:%g, %g, %g, %g', int_lambda(1), int_lambda(2), x, y) );
  
    paramval_x = init_param + x*d;
    
    sensorObj.signalpower = paramval_x(1);
    sensorObj.betasquare = paramval_x(2);
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    % Comment out below to test the conjugate gradient script.
    % paramval = paramval_x;
    % loglhoods = -ones(1,120)/length(steps)*( (paramval(1) -2 )^4 + (paramval(1)-2*paramval(2))^2 );
 
    f_x = sum(loglhoods(steps));
    
    paramval_y = init_param + y*d;
    sensorObj.signalpower = paramval_y(1);
    sensorObj.betasquare = paramval_y(2);
    [loglhoods, sploglhoods ] = snrloglhood( sensorObj, filterObj );
    % Comment out below to test the conjugate gradient script.
    % paramval = paramval_y;
    % loglhoods = -ones(1,120)/length(steps)*( (paramval(1) -2 )^4 + (paramval(1)-2*paramval(2))^2 );
    
    f_y = sum(loglhoods(steps));
    
    disp( sprintf('f_x and f_y:%g', f_x, f_y) );
    if f_x>f_y % converted to greater than to maximise
       int_lambda(2) = y;
       y = x;
       x = int_lambda(2) - 0.618*( int_lambda(2) - int_lambda(1) );
    else
        int_lambda(1) = x;
        x = y;
        y = int_lambda(1) + 0.618*( int_lambda(2) - int_lambda(1) );
        
    end
end

param_est = init_param + mean(int_lambda)*d;
