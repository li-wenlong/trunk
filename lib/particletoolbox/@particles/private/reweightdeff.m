function ws = reweightdeff( ws, states )
% function ws = reweightdeff( ws, states )
% This method finds new weights for a weight defficient array of states
% the updated weight wu(i) = w(i) + a*m(i)
% 
ws = ws(:);
N_eff_des = size( states , 1 );

N = length(ws);


as = roots([(N-N^2/N_eff_des) (2-2*N/N_eff_des) (1-1/N_eff_des)]);
aind = find(as>0);
if ~isempty( aind )
    a = as( aind );
else 
    a = 1;
end

w_mod = ones( 1, N );
% Now find the share of the components from a

% First, resample
idx = resample( ws, N );
% Find the distance matrix of the particles to the
% resampled ones
[dmat] = distmat( states');
ds = min( dmat(idx,:) );
% max_ds = max(ds);
% w_mod = 1 - ( 1/(max_ds + eps) )*ds;
%w_mod = 1./(1+ds.*log10(1+ds));
w_mod = 1./(1+ds(:) );
w_mod = N*w_mod/sum(w_mod);
ws = ws+a*w_mod;
ws = ws/sum(ws);
N_eff = 1/sum(ws.^2);