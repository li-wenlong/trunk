function [G, varargout] = getnoisemap( this, obs )

Zs = obs.Z;

% For the rayleigh case
% b = sqrt( beta^2/2)
G = raylpdf( Zs(:), sqrt( this.betasquare/2 ) );
G = reshape( G, this.numrows, this.numcols );