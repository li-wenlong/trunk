function e = evaluate( g, varargin )

xin = 0;
if nargin>=2
    x = varargin{1};
    xin = 1;
end    

for i=1:length(g(:))
    if xin==0
       x = g(i).m;
    end
    if g(i).isScalar ~= 0
        warning('Trying to evaluate scalar (zeroth power object)');
        e(i,1:size(x,2)) = g(i).sval;
    else

        e(i,:) = g(i).Z*exp(-0.5*sum( ( repmat( g(i).m, 1, size(x,2) ) - x )...
            .*( g(i).S*( repmat( g(i).m, 1, size(x,2) ) - x ) ),1));
    end
end