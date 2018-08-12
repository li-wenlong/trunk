function rss_meas = genrssmeas( d, varargin )

N = 1;
if nargin>=1
    N = varargin{1}(1);
end

P0 = 20;
d0 = 1;
sigmadB = 6;
mu = 3.5;

rss_meas = [];
for i=1:N
    rss_meas(i) = P0 - 10*mu*log10(d/d0 ) + randn*sigmadB;    
end