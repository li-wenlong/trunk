function l = rsslhood( P, ds )


P0 = 20;
d0 = 1;
sigmadB = 6;
mu = 3.5;

l = zeros( size(ds) );

for i=1:length(l)
    d = ds(i);
    l(i) =  exp( -0.5*(P -(P0-10*mu*log10(d/d0) ) )^2/sigmadB^2);
end
l = l/(sqrt(2*pi)*sigmadB);
