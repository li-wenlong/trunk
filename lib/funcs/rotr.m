function xt = rotr( r, psi, x )
% ROTR rotates the vector x psi rad.s around vector r, w.r.t. the right
% hand rule

r = r(:)/norm(r);
x = x(:);
% This is the part of x that is along with r
xp = x'*r;

% This is the orthogonal part of x 
xo = x - xp;

R_be = dcm(psi,0,0);

% Transform the ortho part
xot = R_be'*xo;

xt = xp + xot;