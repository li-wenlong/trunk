function x = genuniasymlap( varargin )
% genuniasymlap samples from univariate asymmetric laplacian distribution
% AL_1( m, sigmasq )
% x = genuniasymlap returns 1 sample from the symmetric univariate
% laplacian AL_1( 0, 1).
% x = genuniasymlap(N) returns N samples from AL_1( 0, 1).
% x = genuniasymlap(N, m) returns N samples from  AL_1( m, 1 ).
% x = genuniasymlap(N, m, sigmasq ) returns N samples from  AL_1( m,
% sigmasq).
% Check asymlaplacian for the closed form of AL_d( m, C ).
% Murat Uney 12-Jun-2009 21:14:50


if nargin == 0
    N = 1;
    m = 0;
    sigmasq = 1;
elseif nargin == 1
    if ~isnumeric(varargin{1})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = 0;
        sigmasq = 1;
    end
elseif nargin == 2
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = varargin{2}(1);
        sigmasq = 1;
    end
else
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2}) || ~isnumeric(varargin{3})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = varargin{2}(1);
        sigmasq = varargin{3}(1);
    end
end

% Generate z ~ exp(-z)
conv_buffer = genexp( N*2 );
z = conv_buffer(end-N+1:end);

% Generate u ~ N(0, sigmasq)
conv_buffer = randnrm( N*2 );
u_tilde = conv_buffer(end-N+1:end);
u = sqrt(sigmasq)*u_tilde(:);

x = z*m + sqrt(z).*u;

