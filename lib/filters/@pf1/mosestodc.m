function [Xh, varargout] = mosestodc( this, varargin )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
Cs = {};
indxs = {};
clmass = [];

if ~isempty( this.post)
Xh = this.post.mean;
end

if nargout >= 2
    varargout{1} = Cs;
end

if nargout >= 3
    varargout{2} = indxs;    
end
if nargout >= 4
    varargout{3} = clmass;
end
