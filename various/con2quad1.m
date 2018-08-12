function [init_lambda] = con2quad1(x,d)
% This function finds and interval for lambda such that
% y= x+lambda*d stays in the first quadrant.

if d(:)'*[1,1]'>0
    % x + d is pointing towards the first quadrant, anyways
    init_lambda = [0 inf];
    return;
end

% Find the intersection with the x-axis at [alpha,0]

lambda_x = -x(2)/d(2);
alpha_x = x(1) + lambda_x*d(1);%

if lambda_x>0
    init_lambda = [0, lambda_x - 1.0e-5];
    return;
end
% Else, the intersection is with the y-axis at [0, alpha]
lambda_y = -x(1)/d(1);
alpha_y = x(2) - x(1)*d(2)/d(1);
init_lambda = [0, lambda_y - 1.0e-5];
