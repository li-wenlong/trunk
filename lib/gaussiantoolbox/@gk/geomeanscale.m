function [lK, varargout] = geomeanscale( p1, p2 )
% geomeanscale( p1, p2 ) returns the scale factor for scaling the geometric
% mean of Gaussian densities p1 and p2 which are @gk objects.

% Murat Uney

% Fetch the variable matrices etc.
C1 = p1.C;
C2 = p2.C;
m1 = p1.m;
m2 = p2.m;
S1 = p1.S;
S2 = p2.S;

z1 = p1.Z; % this is 1/ ( 2pi)^d/2 | C |^1/2
z2 = p2.Z;

dim = size( C1, 1 );

Sf =  (S1 + S2)/2 ;
Cf = inv( Sf );
mc =  (S1*m1+S2*m2)/2; % kinda centre
mf = Cf*mc;

zf = 1/( ((2*pi)^(dim/2) )*det( Cf )^(1/2) );

% Below is a term that appears in the exponent
eterm = (1/2)*(mc'*mf) - (1/4)*( m1'*S1*m1 + m2'*S2*m2 );

K1 = sqrt( z1*z2 )*( (2*pi)^(dim/2) ); % This leaves 1/( det(C1)det(C2) )^1/4
K2 = ( zf*( (2*pi)^(dim/2) ) )^(-1); % This leaves 1/det(Cf)^1/2

K =  K1*K2*exp( eterm );
lK = log(K1) + log(K2) + eterm;

% Below are equivalent computations for lK
% k1 = inv( det(C1)*det(C2) )^(1/4);
% k2 = inv( det( Sf ) )^(1/2);
%lK = log(k1) + log(k2) + eterm

if nargout>=2
    varargout{2} = K;
end


