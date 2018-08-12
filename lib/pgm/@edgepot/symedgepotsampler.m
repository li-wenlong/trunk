function [varargout] = symedgepotsamples( this, varargin)
% symedgepotsamples method of the class @edgepot
% Returns a set of particles sampled from a symmetric edge potential
% phi( \theta_j - \theta_i ) over the edge (i,j)
% by generating samples from a Kernel Density Estimate of phi( \theta_j - \theta_i )
% [m, w] =  symedgepotsamples( myedgepot ) returns particles m and
% weights w (before resamling).
% The inputs are
% myedgepot: an edgepot object capturing p(xi , xj)
% \propto phi( \theta_j - \theta_i )

% Murat Uney 28.05.2017
% Murat Uney 07.05.2017

numSamples = 100;
if nargin>=2
    numSamples = varargin{1};
end

if isa(this.potobj,'gk')
    % Generate samples from the edge potential variable and find the kde
    p = this.potobj.gensamples( numSamples );
    
elseif isa(this.potobj,'particles')
    p = this.potobj.sample( numSamples );

else
    error('Objects of class %s not handled!', class( this.potobj ) );
end

varargout{1} = p; % m;
if nargout >=2
    varargout{2} = this.potobj.evaluate( p );
end


