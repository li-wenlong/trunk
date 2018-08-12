function varargout = getclutter(this, varargin)


out = {};

inds = find( rand(1, this.n ) < this.p );


varargout{1} = inds;

