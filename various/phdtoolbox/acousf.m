function f = acousf( x, varargin )
%  ACOUSF acoustic sensor f function given by
%  f( ksi ) = ksi^3/2.5e+8-ksi^2/1.5e+5 + 1, ksi<=500
%           = 250/ksi,  ksi>500
%  with ksi = ||x-s||^alpha where x is the emitter locations and s is the
%  location of the sensor
%
% f = acousf( x ) returns a column vector for target locations x and the 
% sensor located at the origin and alpha = 2.
% f = acousf( x, s ) returns for the array of target locations x and the 
% array of sensor location s with alpha=2 and MxN array where the the rows
% are for the targets and the columns are for the sensors.
% f = acousf( x, s, alpha ) returns an MxN array for the specified value of
% alpha.
%

% Murat Uney

if nargin >= 1
    if ~isnumeric(x) || ndims(x)~=2
        error('x is an array of target locations!');
    end
    [D, N] = size(x);
else
    f=1;
    return;
end
s = zeros(D,1);
Ds = D;
M = 1;
if nargin >=2
    s = varargin{1};
    if ~isnumeric(s) || ndims(s) ~=2
        error('s is an array of sensor locations!');
    end
    [Ds, M] = size(s);
    if Ds ~= D
        error('The dimensions of both target and sensor locations should be same!');
    end
end
alph = 2;
if nargin == 3
    alph = varargin{2};
    if ~isnumeric(alph)
        error('alpha should be of type numeric');
    end
    alph = alph(1);
end
f = zeros(N, M);

for i=1:M
    d = x - repmat(s(:,i),1,N);
    d = d';
    ksi = sqrt( sum( d.*d, 2) ).^(alph);
    gi = find(ksi<=500);
    li = find(ksi>500);
    f(li,i) = 250./ksi(li);
    if ~isempty(gi)
        f(gi,i) = (ksi(gi).^3)./(2.5e+8) - (ksi(gi).^2)./(2.5e+5)+1;
    end
end
