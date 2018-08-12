function c = ggcor( h, varargin )
% GGCOR is the Correlation function for the Gaussian geostatistical models
% considering geographic variables x_1, x_2, ... collected at locations
% s_1, s_2, ...and the model given by C(x_1, x_2) = C( ||s_1 - s_2 ||)
% such that 
% C(h) = sigma^2 1/(2^(nu-1)Gamma(nu)) * (2 sqrt(nu) h/ phi) 2 * K_nu (2
% sqrt(v) h/ phi), h>0
% C(h) = tau^2 + sigma^2, h = 0
% where h = ||s_1-s_2|| and K_nu() the modified Bessel function of the
% third (second) kind of order nu.
% C = ggcor(h) returns the covariance function evaluated at h with 
% the nugget effect: tau^2 = 0.5
% the partial sill: sigma^2 = 0.5
% the effective range of covariance: phi = 10
%
% C = ggcor(h, Specs) evaluates the covariance function using the parameters of
% the model specified by Specs with any of the following field names:
% 'tausq', 'sigmasq', 'phi', 'nu'
%
% For more information  check e.g. Song, Fuentes, Ghosh, ``A comparative
% study of Gaussian geostatistical models and gaussian markov random field
% models,'' Journal of multivariate Analysis, 99 (2008) 1681-1697
%
%   See also GGM, GEOGMRF, GAUSSCOND, GAUSSMARG, GKLD

% Murat Uney

tauSq = 0.5;
sigmaSq = 0.5;
phi = 10;
nu = 1;

if nargin<1
    error('Please provide input arguments!')
elseif nargin >1
    for j=1:2:length(varargin)
        switch lower( varargin{j})
            case {'tausq'}
                tauSq = varargin{j+1};
                if isnumeric(tauSq)
                    tauSq = tauSq(1);
                    if tauSq < 0
                        error('tausq should be non-negative!');
                    end
                else
                    error('tausq should be a scalar!');
                end
            case {'sigmasq'}
                sigmaSq = varargin{j+1};
                if isnumeric(sigmaSq)
                    sigmaSq = sigmaSq(1);
                    if sigmaSq < 0
                        error('sigmasq should be non-negative!');
                    end
                else
                    error('sigmasq should be a scalar!');
                end
            case {'phi'}
                phi = varargin{j+1};
                if isnumeric(phi)
                    phi = phi(1);
                    if phi < 0
                        error('phi should be non-negative!');
                    end
                else
                    error('phi should be a scalar!');
                end
            case {'nu'}
                nu = varargin{j+1};
                if nu < 0
                    error('nu should be non-negative!');
                end
                if isnumeric(nu)
                    nu = nu(1);
                else
                    error('nu should be a scalar!');
                end
        end
    end
end

if ~isnumeric(h)
    error('Location must be of type numeric');
end

c = zeros(size(h));
c = sigmaSq*(1/(2^(nu-1)*gamma(nu)))*( (2*sqrt(nu)*h)/phi).^nu.*besselk(nu, (2*sqrt(nu)*h)/phi )*2;
c(find(h(:)==0)) = tauSq + sigmaSq;

