function olen = outplen(this)

if isempty( this.postintensity)
    olen = 0;
else
    olen = this.postintensity.s.particles.getnumpoints;
end