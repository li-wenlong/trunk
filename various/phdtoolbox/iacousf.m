function d = iacousf( f, varargin )
% IACOUSF is the inverse acoustic function returning the distances give f
%
% d =  iacousf( f ) returns the distance corresponding to the acousf values
% given by f, assuming that alpha = 2
%
% d = iacousf( f, alph ) returns the distance for the attenuation coeff
% alph.
%
% See also ACOUSF

% Murat UNEY

if nargin >= 1
    if ~isnumeric(f)
        error('f should be a numeric array!');
    end
    alph = 2;
else
    error('At least one argument must be entered!');
end
if nargin == 2
    alph = varargin{1}(:);
    if ~isnumeric( alph )
        error('The second argument should be of type numeric!');
    end
end

d = zeros(size(f));
% ksi = 500 is the threshold for f(ksi)
% 250/500 is the threshold for f^-1
threshold = 0.5;

ind = find( f <= threshold); % These are given by f = 250/ksi
d(ind) = 250./f(ind); % For now d = ksi

ind = find(f > threshold ); % These are given by f = ksi^3/2.5e+8 - ksi^2/2.5e+5 + 1
for i=1:length(ind)
%    rts = roots([1/2.5e+8 -1/2.5e+5 0 1-f(i)]);
    rts = roots([1 -1000 0 (1-f(ind(i)))*2.5e+8]);
    rtind = find(rts>=0 & rts<500 );
    if isempty(rtind)
        error('f is not ivertible?');
    end
    d(ind(i)) = rts(rtind(1));
end
d = d.^(1/alph);


