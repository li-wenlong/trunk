function m = snr2mse( s, varargin )
% SNR2MSE equivalent MSE of SNR under additive Gaussian noise, i.e.
% y = x + n where n~N(n; 0,sigmasq_n) with N indicating the normal distribution.
%
% Considering sigmasq_x and sigmasq_n being the power of the signal and the
% noise respectively ( which are corresponding variances in a probabilistic
% model ) the SNR is given by 
% SNR = 10*log10(sigmasq_x/sigmasq_n)  (1)
% and the MSE considering x~N(x; 0,sigmasq_x), n~N(n; 0,sigmasq_n) and 
% the MMSE (equivalently the MAP estimator since the distributions are 
% Gaussian ) is given by 
% MSE = sigmasq_x*sigmasq_n/(sigmasq_x+sigmasq_n) (2)
% and is the % variance of the posterior p_xGy
% 
% The correspondance between the SNR and the equivalent MSE is obtained
% through (1) and (2) and given by
%
% MSE = sigmasq_x/(1+10^(SNR/10))
%
% m = snr2mse( s ) returns the equivalent MSE for SNR = s and
% sigmasq_x=1.
%
% m = snr2mse( m, ssq ) returns the equivalent MSE for SNR = s and
% sigmasq_x= ssq.
%
% See also mse2snr, gaussmarg, gausscond
%

% Murat Uney
if nargin>2
    error('Too many input arguments!');
elseif nargin==0
    error('At least 1 input argument is needed!');
else
    ssq = 1;
    if nargin ==2
        ssq = varargin{1}(1);
    end
    
end

if ~isnumeric(s) || ~isnumeric(ssq)
    error('Input argument(s) should be scalars!');
end

m = ssq./(1+10.^(s/10));