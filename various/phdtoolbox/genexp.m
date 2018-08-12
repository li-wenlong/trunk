function z = genexp( varargin )
% genexp sample from the univariate exponential distribution
% z ~ p(z) where p(z) = PIECEWISE([(1/lambda_z)*exp(-z/lambda_z), z>=0], [0, z<0]).
% z = genexp returns 1 sample from exp(-z), i.e. lambda_z = 1.
% z = genexp( N ) returns N samples from exp(-z).
% z = genexp( N, lambda_z ) returns N samples from
% (1/lambda_z_)*exp(-z/lambda_z_).
% Murat Uney

if nargin == 0
    lambda_z_ = 1;
    N = 1;
elseif nargin == 1
    if ~isnumeric(varargin{1}) 
        error('Wrong type of input arguments');
    else
        lambda_z_ = 1;
        N = varargin{1}(1);
    end
else
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2})  
        error('Wrong type of input arguments');
    else
        lambda_z_ = varargin{2}(1);
        N = varargin{1}(1);
    end
end
%twister('state',100*clock);
% Generate uniform random variables
conv_buffer = twister(N*2,1);

% Just apply the F^-1(u) rule
z = -log( conv_buffer(end-N+1:end) )*lambda_z_;