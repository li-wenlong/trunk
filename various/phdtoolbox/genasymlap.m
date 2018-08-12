function x = genasymlap( varargin )
% genasymlap samples from the symmetirc/asymmetric laplacian distribution
% AL_d( m, Sigma ) where d is the dimensionality, m is the mean vector,
% Sigma is the covariance matrix. The distribution is symmetric if m is the
% zero vector (e.g. m=0 for d=1). 
% The generation process is x=sqrt(z)*m + sqrt(z)*u
% where z is sampled from the unit univariate exponential distribution 
% independent from u which is sampled from a normal distribution of
% covariance matrix Sigma.
% x = genuniasymlap(N) returns N samples from AL_1( 0, 1).
% x = genuniasymlap(N, m) returns N samples from  AL_dim(m)( m, I ).
% x = genuniasymlap(N, m, Sigma ) returns N samples from  AL_dim(m)( m,
% Sigma).
% x = genuniasymlap(N, m, Sigma, Lambda ) returns N samples from  AL_dim(m)( m,
% Sigma) and substitute Lambda = Sigma^(1/2) where necessary.
% Check asymlaplacian for the closed form of AL_d( m, C ).
% Murat Uney

if nargin == 0
    N = 1;
    m = 0;
    D = 1;
    Sigma = 1;
    Lambda = 1/Sigma;
elseif nargin == 1
    if ~isnumeric(varargin{1})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = 0;
        D = 1;
        Sigma = 1;
        Lambda = 1/Sigma;
    end
elseif nargin == 2
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = varargin{2}(:);
        D = length(m);
        Sigma = eye(D);
        Lambda = Sigma;
    end
elseif nargin == 3
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2}) || ~isnumeric(varargin{3})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = varargin{2}(:);
        D = length(m);
        Sigma = varargin{3};
        if length(size(Sigma))~=2 || size(Sigma,1 )~=D || size(Sigma,2 )~=D
            error('Sigma should be a DxD matrix where D is dimensionality of m.');
        end
        Lambda = Sigma^(1/2);
    end
else
    if ~isnumeric(varargin{1}) || ~isnumeric(varargin{2}) || ~isnumeric(varargin{3}) || ~isnumeric(varargin{4})
        error('Wrong type of input arguments');
    else
        N = varargin{1}(1);
        m = varargin{2}(:);
        D = length(m);
        Sigma = varargin{3};
        Lambda = varargin{4};
        if length(size(Sigma))~=2 || size(Sigma,1 )~= D || size(Sigma,2 )~= D
            error('Sigma should be a DxD matrix where D is dimensionality of m.');
        end
        if length(size(Lambda))~=2 || size(Lambda,1 )~= D || size(Lambda,2 )~= D
            error('Lambda should be a DxD matrix where D is dimensionality of m.');
        end
        if sum(sum((Sigma-Lambda*Lambda).^2))>10*eps
            error('Lambda is not the inverse of Sigma!');
        end
    end
end


% Generate z ~ exp(-z)
conv_buffer = genexp( N*2 );
z = conv_buffer(end-N+1:end);

% Generate u ~ N(0, Sigma)
conv_buffer = randnrm(N*D*5);
u = Lambda*reshape( conv_buffer(end-N*D+1:end), D, N );
x = m*z' + (repmat(sqrt(z)',D,1).*u);

