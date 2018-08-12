function i = xmitrcvint(these)
% XMITRCVINT returns a GM density representation for the particle
% representation of an intensity.

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

% remove the particles
i.s.particles = [];

