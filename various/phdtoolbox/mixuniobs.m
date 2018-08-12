function y = mixuniobs( mixsamples, varargin )
% MIXUNIOBS samples from the mixture of uniform distributions U and hence
% produces observations from p(y) = int_X p(y|x) p(x) where p(y|x) is a
% uniform distribution centered at x and of width 1, e.g. if x = 0 =>
% p(y|x=0)= U[-0.5,0.5]
% y = mixuniobs( mixsamples ) simply adds a uniform distributed independent
% noise to the array mixsamples.
% y = mixuniobs( mixsamples, O ) mixes mixsamples by generating O
% observations for each element of mixsamples using U[-0.5,0.5].
% y = mixuniobs( mixsamples, O, U ) mixes mixsamples by generating O
% observations for each element of mixsamples using U[-U,U].
%
% See also MIXNORMOBS

% Murat Uney

if nargin == 0
    error('Insufficient input arguments provided!');
elseif nargin == 1
    if ~isnumeric( mixsamples )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O =  1;
        U = 0.5;
    end
elseif nargin ==2
    if ~isnumeric( mixsamples )||~isnumeric( varargin{1} )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O = varargin{1}(1);
        U = 0.5;
    end
else
    if ~isnumeric( mixsamples )||~isnumeric( varargin{1} )|| ~isnumeric( varargin{2} )
        error('Wrong type of input arguments');
    else
        mixsamples = mixsamples(:);
        O = varargin{1}(1);
        U = varargin{2}(1);
    end
end

nummixsamples = length(mixsamples);
numobs = O*nummixsamples;

% Generate 
buff = twister(numobs*2,1);
u = buff(end-numobs+1:end);
mixsamples = repmat(mixsamples,1,O );
mixsamples = mixsamples';
y = (u*2*U-U) + mixsamples(:);

        
    