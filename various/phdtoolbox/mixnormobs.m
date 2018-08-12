function y = mixnormobs( mixsamples, varargin )
% MIXNORMOBS samples from the mixture of normal distributions N and hence
% produces observations from p(y) = int_X p(y|x) p(x) where p(y|x) is a
% normal distribution centered at x and of variance sigmasq, e.g. if x = 0 =>
% p(y|x=0)= N(0, sigmasq )
% y = mixuniobs( mixsamples ) simply adds a normal distributed independent
% noise variance 1 to the array mixsamples.
% y = mixuniobs( mixsamples, O ) mixes mixsamples by generating O
% observations for each element of mixsamples using N(0,1).
% y = mixuniobs( mixsamples, O, S ) mixes mixsamples by generating O
% observations for each element of mixsamples using N(0,S).
%
% See also MIXUNIOBS

% Murat Uney

if nargin == 0
    error('Insufficient input arguments provided!');
elseif nargin == 1
    if ~isnumeric( mixsamples )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O =  1;
        S =  1;
    end
elseif nargin ==2
    if ~isnumeric( mixsamples )||~isnumeric( varargin{1} )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O = varargin{1}(1);
        S = 1;
    end
else
    if ~isnumeric( mixsamples )||~isnumeric( varargin{1} )|| ~isnumeric( varargin{2} )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O = varargin{1}(1);
        S = varargin{2}(1);
    end
end

nummixsamples = length(mixsamples);
numobs = O*nummixsamples;

% Generate 
buff = randnrm(numobs*2);
u = buff(end-numobs+1:end);
mixsamples = repmat(mixsamples,1,O );
mixsamples = mixsamples';
y = sqrt(S)*u(:) + mixsamples(:);

        
    