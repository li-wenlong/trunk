function [x_star ] = solveioverj( gmm, i, j, varargin )


if nargin >= 3
    sc = varargin{1}(1);
else
    sc = 1;
end

x_star = solveioverj( gmm.pdfs(i) , gmm.pdfs(j), gmm.w(j)*sc/gmm.w(i));

