function p_x = asymlaplacian(varargin)
% asymlaplacian returns the symbolic expression of a general asymmetric
% laplacian distribution AL_d( m, C_u ).
% p_x = asymlaplacian returns the symbolic expression for a univariate
% symmetric laplacian , i.e. AL_1( 0, 1 ), in the variable name x.
% p_x = asymlaplacian( v ) returns the symbolic expression for a univariate
% symmetric laplacian , i.e. AL_1( 0, 1 ), in the variable name beared by 
% the symbolic expression v. 
% p_x = asymlaplacian( v, C_u ) returns the symbolic expression for a multivariate
% symmetric laplacian , i.e. AL_d( 0, C_u ), in the variable name beared by v.
% p_x = asymlaplacian( v, C_u, m ) returns the symbolic expression for a multivariate
% asymmetric laplacian , i.e. AL_d( m, C_u ), in the variable name beared by v.
% p_x = asymlaplacian( v, C_u, m, Lambda_u ) returns the symbolic expression for a 
% multivariate asymmetric laplacian , i.e. AL_d( m, C_u ), in the variable
% name beared by v by substituting Lambda_u = C_u^-1 where necessary.

% Murat Uney

 
if nargin==0
    syms x
    d = 1;
    C_u = 1;
    m = 0;
    Lambda_u = 1;
elseif nargin == 1
    if isempty( findsym(varargin{1}) )
        error('Single input should be of type symbolic!');
    end
    x = varargin{1}(:);
    d = length(x);
    C_u = eye(d);
    m = zeros(d,1);
    Lambda_u = eye(d);
elseif nargin == 2
    if isempty( findsym(varargin{1}) ) || ~isnumeric(varargin{2})
        error('Wrong type of input arguments!');
    end
    x = varargin{1}(:);
    d = length(x);
    C_u = varargin{2};
    if sum( abs(size(C_u) - [d d]))> eps
        error('The dimensionality of the covariance matrix should match the dimensionality of the variable vector!');
    end
    m = zeros(d,1);
    Lambda_u = C_u^(-1);
elseif nargin == 3
    if isempty( findsym(varargin{1}) ) || ~isnumeric(varargin{2}) ||  ~isnumeric(varargin{3}) 
        error('Wrong type of input arguments!');
    end
    x = varargin{1}(:);
    d = length(x);
    C_u = varargin{2};
    if sum( abs(size(C_u) - [d d]))> eps
        error('The dimensionality of the covariance matrix should match that of the variable vector!');
    end
    m = varargin{3}(:);
    if length( m ) ~= d
       error('The dimensionality of the mean vector should match that of the variable vector!');
    end
    Lambda_u = C_u^(-1);
elseif nargin == 4
    if isempty( findsym(varargin{1}) ) || ~isnumeric(varargin{2}) ||  ~isnumeric(varargin{3}) ||  ~isnumeric(varargin{4}) 
        error('Wrong type of input arguments!');
    end
    x = varargin{1}(:);
    d = length(x);
    C_u = varargin{2};
    if sum( abs(size(C_u) - [d d]))> eps
        error('The dimensionality of the covariance matrix should match that of the variable vector!');
    end
    m = varargin{3}(:);
    if length( m ) ~= d
       error('The dimensionality of the mean vector should match that of the variable vector!');
    end
    Lambda_u = varargin{4};
    if sum( abs(size(Lambda_u) - [d d]))> eps
        error('The dimensionality of the inverse covariance matrix should match that of the variable vector!');
    end
    if sum(sum((2*eye(d)-Lambda_u*C_u -C_u*Lambda_u ).^2 ))> 100*eps
        error('The multiplication of the covariance matrix with its inverse does not yield eye!');
    end
end

v = (2-d)/2;
if d==1
    p_x =  ( 1/sqrt( m^2+2*C_u ) )*exp(-abs(x)*sqrt( m^2+2*C_u )/C_u + m*x/C_u );
else
    p_x = ( 2*exp(x.'*Lambda_u*m)/ ( (2*pi)^(d/2)*det(C_u)^(1/2) ) )*( x.'*Lambda_u*x/(2+ m'*Lambda_u*m) )^(v/2)...
        *besselk(v, sqrt( (2+ m'*Lambda_u*m)*(x.'*Lambda_u*x) ));
end
