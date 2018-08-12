function p1 = horzcat( p1, varargin )

for i=1:length(varargin)
    p1 = join( p1, varargin{1} );
end
p1.normalise;