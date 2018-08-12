function [varargout] = symedgepotsamples( pwpot, varargin)
% function [m] = symedgepotsamples( pwpot )
% Returns a set of particles sampled from a symmetric edge potential
% phi( \theta_j - \theta_i ) over the edge (i,j)
% by generating samples from a Kernel Density Estimate of phi( \theta_j - \theta_i )
% [m, w] =  symedgepotsamples( pwpotparams) returns particles m and
% weights w (before resamling).
% The inputs are
% pwpotparams: a structure accommodating the joint distribution p(xi , xj)
% \propto phi( \theta_j - \theta_i )

% Murat Uney 28.05.2017
% Murat Uney 07.05.2017

numSamples = 100;
if nargin>=2
    numSamples = varargin{1};
end

if isa(pwpot,'gk')
    % Generate samples from the edge potential variable and find the kde
    p = pwpot.gensamples( numSamples );
    w = pwpot.evaluate( p );
elseif isa(pwpot,'particles')
    p = pwpot.sample( numSamples );
    w = pwpot.evaluate( p );  
else
    error('Objects of class %s not handled!', class( pwpot) );
end

varargout{1} = p; % m;
if nargout >=2
    varargout{2} = w;
end


