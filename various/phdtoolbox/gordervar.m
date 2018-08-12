function [C_r, varargout ] = gordervar(C_x, v_ind, varargin )

if nargin>=3
    mu_x = varargin{1}(:);
else
    mu_x = zeros( size(C_x,2) ,1);
end

N = length( mu_x );



% Now E reorders the variable entries such that x_r = E x;
E = eye(N);
E = E( [v_ind],:);

C_r = E*C_x*E';
mu_r = E*mu_x;

if nargout>=2
    varargout{1} = mu_r;
end
if nargout>=3
    varargout{2} = E;
end
