function [x] = gensamples( gk, varargin )


numsamples = 1;
if nargin>=2
    numsamples = varargin{1}(1);
end

[d,nm] = size(gk.m);
x = reshape( randn(d*numsamples,1), [d,numsamples]);
if nargin >= 2
    if d == 1
        S = sqrt(gk.C);
    else
        S = chol(gk.C);
    end
    if d == 1
        x = S .* x;
    else
        x = S' * x;
    end
end
if nm == 1
    x = x + repmat(gk.m, 1, numsamples);
else
    x = x + gk.m;
end