function  [ C_f, a_f, B_f  ] = emdocond( C_0, a_0, B_0, C_1, a_1, B_1 , varargin )
% EMDOCOND finds the parameters for the exponential mixture density (EMD)
% (or, covariance intersection) of two conditional Gaussian densities
% p0(x|y,y0) and p1(x|y,y1) parameterised as (C0,a0,B0) for representing
% N( x; mu0 = a0+ B0 [y;y0], C0 ) and N( x; mu1 = a1+ B1 [y;y1], C1 )
% which is a general representation for a conditional of a Gaussian joint model
% p(x,y)
% 


w = 0.5;
if nargin >= 7
    w = varargin{1}(1);
    if w<0 || w>1
        error('w has to be a real number between 0 and 1!');
    end
end

% the common elements in the condition
cel = [1:size(B_0,2)];
if nargin>=8 
    cel = varargin{2}(:);
    if length(cel)> min( size(B_0,2), size(B_1,2) );
        error('c has to be an array of common elements and cannot exceed the minimum number of coloumns of B0 and B1');
    end
end

% First, find the information matrices 

R = chol(C_0);
Rinv = R^(-1);

Lambda_0 = Rinv*Rinv';

R = chol(C_1);
Rinv = R^(-1);

Lambda_1 = Rinv*Rinv';

% Now, the information matrix of the EMD
Lambda_f = (1-w)*Lambda_0 + (w)*Lambda_1;

% Now, invert it to find the covariance matrix of the EMD
R = chol(Lambda_f);
Rinv = R^(-1);

C_f = Rinv*Rinv';
% Done!

% Second, find the linear transform parameterising the mean vector

% 1 The selection matrices E0 and E1 for mu0 = a0 + B0E0 [y;y0;y1] 
% and mu1 = a1 + B1E1 [y;y0;y1]
lenc = length( cel ); % this is number of common fields
lenz0 = size(B_0,2);
leny0 =  lenz0 - lenc ;
lenz1 = size(B_1,2);
leny1 =  lenz1 - lenc;

E_0 = [ eye( lenz0 ), zeros( lenz0, leny1  ) ];
E_1 = [  [eye( lenc ); zeros( leny1, lenc) ], ...
    zeros( lenz1, leny0), ...
    [ zeros( lenc , leny1 ) ; eye(leny1) ]  ];


B_f = C_f*( (1-w)*Lambda_0*B_0*E_0 + w*Lambda_1*B_1*E_1 );
a_f = C_f*( (1-w)*Lambda_0*a_0 + w*Lambda_1*a_1 );




    
    