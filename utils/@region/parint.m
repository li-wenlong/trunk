function val = parint( this, p, varargin )

[d, N] = size( p );

if isempty( varargin )
    w = ones(N,1)/N;
else
    w = varargin{1};
end

i = this.isin( p );
val = sum(w(i) );
    