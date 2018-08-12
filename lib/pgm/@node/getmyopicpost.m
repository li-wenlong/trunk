function mp = getmyopicpost( this, varargin )
% function mp = @node.myopicpost
% returns the myopic posterior mp as a Gaussian Kernel @gk object given the
% measurement value @node.y and prior stored in @node.state as a @gk object.
% mp = @node.myopicpost( y) computes the posterior for y.

% Murat Uney 01.2014
% Murat Uney 05.2017  handles multi-dimensional noise

if nargin>=2
    y_vect = varargin{1};
else
    y_vect = this.y;
end

Lambda_x = this.initstate.S;
mu_x = this.initstate.m;
C_n_j = this.noisedist.C;
S_n_j = this.noisedist.S;
mu_y = mu_x + this.noisedist.m;

dx = size(Lambda_x,1);

C_xy_inv = [ Lambda_x + eye( dx )*S_n_j , -eye( dx )*S_n_j ;...
    -eye( dx )*S_n_j, eye( dx )*S_n_j];

C_xy = C_xy_inv^(-1);

[C_xGy, mu_xGy, a_xGy, B_xGy ] = gausscond( C_xy, [size(Lambda_x,1)+1:size(C_xy,1) ] , [mu_x;mu_y], y_vect );

mp = cpdf( gk(C_xGy, mu_xGy ) );