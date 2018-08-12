function [ ri, rj ] = lingaussqtsl( pi, pj, si, sj )
% function [ri, rj ] = lingaussqtsl( pi, pj, si, sj )
% This function finds the "r" terms of the quad-term separable likelihood 
% for the linear Gaussian state space model case.
% [ri, rj ] = lingaussqtsl( pi, pj, si, sj )
% pi and pj are Gaussian Kernel objects (gk) and are the posteriors from
% the local KF shifted in accordance with the \theta_ij value. si and sj
% are @linobs instances which capture the observation model.
% 

ri = findr( pj, si );
rj = findr( pi, sj );

end
function [ri] = findr( pj, si )

H = si.linTrans;
R = si.noiseCov;
 
[dim] = pj.getdims;

obs = si.srbuffer(end);
dimZ = length(obs.Z.Z );

[d1,d2] = size(H);
H_ = [H, zeros( dimZ , dim-d2 ) ];


ri = cpdf( gk( H_*pj.C*H_' + R, H_*pj.m  ) );

end