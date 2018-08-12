function d = gkld( C_p, C_q, varargin )
% GKLD Gaussian Kullback-Leibler divergence is the Kullback Liebler
% distance D(p||q) = \int p(x) ln p(x)/q(x) where p and q are Gaussian
% distributions and it is given by
% 1/2( ln(det(C_q)\det(C_p)) + tr(C_q^-1 C_p)+ (m_q-m_p)'C_q^-1(m_q-m_p)-N)
%
% d = gkld( C_p, C_q ) is the KLD for p = N(x;0,C_p) and q = N(x;0,C_q)
%
% d = gkld( C_p, C_q, m_p, m_q ) is the KLD for p = N(x;m_p,C_p) and q = N(x;m_q,C_q)
%
% d = gkld( C_p, C_q, m ) is the KLD for p = N(x;m,C_p) and q = N(x;m,C_q)
% which is exactly equal to gkld( C_p, C_q ).
%
% See also , GAUSSCOND, GAUSSMARG, GGM, GEOGMRF, GKLD

% Murat UNEY
m_p = zeros(size(C_p,1) ,1);
m_q = m_p;

if nargin<2
    error('Not enough input arguments');
elseif nargin>=2
    if ~isnumeric(C_p) | ~isnumeric(C_q)
        error('The inputs should be of type numeric!');
    end
    if ndims(C_p)~=2 | ndims(C_q)~=2
        error('The first two arguments should be matrices!');
    else
        [N, M] = size(C_p);
        if M~=N || N ~=size(C_q,1) || M~=size(C_q,2)
            error('The first two arguments should be square matrices of the same size!');
        end
    end
end

if nargin == 3
    m_p = varargin{1}(:);
    if ~isnumeric(m_p)
        error('All inputs should of type numeric');
    end
    if length(m_p)~=N
        error('Size of the correlation matrix and the mean vector missmatch!');
    end
    m_q = m_p;
elseif nargin==4
    m_p = varargin{1}(:);
    m_q = varargin{2}(:);
    if ~isnumeric(m_p) || ~isnumeric(m_q)
        error('All inputs should of type numeric');
    end
    if length(m_p)~=N ||  length(m_q)~=N
        error('Size of the correlation matrix and the mean vector missmatch!');
    end
end

d = 1/2*( log(det(C_q)/det(C_p))+ trace(C_q^(-1)*C_p) + (m_q-m_p)'*C_q^(-1)*(m_q-m_p) -N  );
    
        
      