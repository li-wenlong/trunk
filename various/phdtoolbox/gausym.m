function [g, varargout] = gausym(C_x, varargin)
% GAUSYM returns the symbolic expression of the Gaussian density
% corresponding to the given parameters.
%
% g = gausym(C_x) returns the symbolic expression g for p(x) = N(x;C_x,0)
% such that the mean vector is identically zero, the covariance matrix is
% given by C_x and the variable labels are 'x_1', 'x_2',...,'x_N' for an
% NxN C_x.
%
% [g, x] = gausym(C_x) also returns the symbolic vector x.
%
% g = gausym(C_x, mu_x) considers the mean vector mu_x.
%
% g = gausym(C_x, mu_x, x) considers the symbolic vector x containing the
% labels of the variables.
%
% See also GAUSSMARG, GAUSSCOND, GGM

% Murat UNEY

if nargin<1
    error('Not enough input arguments!');
end

if ~isnumeric(C_x)&& ~isa(C_x,'sym')
    error('First argument should be a square numerical or symbolic matrix!');
else
    if ndims( C_x )~=2
        error('First argument should be a square matrix!');
    else
        [N, M] = size(C_x);
        if N~= M
            error('First argument should be a SQUARE matrix!');
        end
    end
end


if nargin >= 2
    mu_x = varargin{1}(:);
    if ~isnumeric(mu_x)
        if isempty(findsym(mu_x))
            error('The second argument should be an index array of type numeric or symbolic!');
        end
    end
    if length(mu_x)~=N
        error('The second array should be of length N!');
    end
else
    mu_x = zeros(N,1);
end


if nargin>=3
    x = varargin{2}(:);
    if length(x)~= N
        error('The third argument should be of length N for an NxN C_x!');
    end
    if  isempty(findsym(x))
        error('x should be a symbolic array of length N for an NxN C_x!');
    end
else
    symString = ['x_1'];
    for j=2:N
        symString = [symString,';x_',num2str(j)];
    end
    x = sym(['[',symString,']']);
end
 
g = (1/((2*pi)^(N/2)*sqrt(det(C_x ))) )*exp( -0.5*transpose([x-mu_x])*inv(C_x)*[x-mu_x] );
