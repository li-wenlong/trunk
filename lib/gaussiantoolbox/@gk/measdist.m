function [ pz ] = measdist( px, H, R )
% function [ pz ] = measdist( px, H, R )
% finds the measurement marginal pz for a prior state distribution
% px and a linear Gaussian likelihood associated with the model
% z = Hx+n where n is Gaussian noise with covariance R
%

% Murat Uney

[dim] = px(1).getdims;
[d1,d2] = size(H);
H_ = [H, zeros( d1 , dim-d2 ) ];
pz = cpdf( gk( H_*px(1).C*H_' + R, H_*px(1).m  ) );

if length( px ) >= 2
    pz = [pz; measdist( px(2:end), H, R ) ];   
end