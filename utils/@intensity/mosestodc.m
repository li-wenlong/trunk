function [Xh, varargout] = mosestodc( this )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
if isempty(this)
    return;
end
if isempty( this.s.particles )
    return;
end

particles = this.s.particles*this.s.mu;
[Xh, Cs, indxs ] = particles.mosestodc;
if nargout == 2
    varargout{1} = Cs;
end

if nargout == 3
    varargout{2} = indxs;
end
