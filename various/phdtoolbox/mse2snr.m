function s = mse2snr( m, varargin )
% MSE2SNR equivalent SNR of MSE under additive Gaussian noise, i.e.
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
% The correspondance between the MSE and the equivalent SNR in the sense
% that the MSE is considered as if due to a "single" observation y (but the
% MSE could be due to multiple observations regarding x) is obtained
% through (1) and (2) and given by
%
% SNR = 10*log10( 1/( MSE/(sigmasq_x-MSE) ) )
%
% s = mse2snr( m ) returns the equivalent SNR for the MSE=m and
% sigmasq_x=1.
%
% s = mse2snr( m, ssq ) returns the equivalent SNR for the MSE=m and
% sigmasq_x= ssq.
%
% See also snr2mse, gaussmarg, gausscond
%

% Murat Uney
if nargin>2
    error('Too many input arguments!');
elseif nargin==0
    error('At least 1 input argument is needed!');
else
    if ~isnumeric(m)
        error('First argument should be numeric!');
    end
    ssq = 1;
    if nargin ==2
        if ~isnumeric(varargin{1})
            error('Second argument should be numeric!');
        end
        ssq = reshape( varargin{1}(:), size(m) );
    end
end

s =  10*log10( 1./( m./(ssq-m) ) );


