function i = par2int(these)
% PAR2INT returns an intensity object for the particles representing an
% intensity.

if isempty(these)
    i = intensity;
    i = i([]);
    return;
end
icfg = intensitycfg;
icfg.mu = sum( these.catweights );

dcfg = densitycfg;
dcfg.particles = these*(1/icfg.mu);

icfg.scfg = dcfg;
i = intensity( icfg );

