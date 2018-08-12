function res = prodisgausspair( these )
% This function samples from the product of the particles array in the
% input by using importance sampling with the proposal distribution as the
% mixture of products of Gaussian pairs where the Gaussians are the best
% approximation to the elements of the particles array.

% Murat Uney 19/11/2014
osfactor = 2;
if length(these)==1
    res = these(1);
    res.findkdebws('nonsparse'); % Find kde bandwidths
    res.resample; % make it equally weighted kernels
    res.regwkde; % Generate samples from the equally weighted kernel sum
    return;
end

% Find the proposal distribution
[C_, m_ ] = these(1).par2gauss;
gs(1) = cpdf( gk(C_, m_ ) );
gss(1) = ( gs(1) )^(1/length(these));
for i=2:length(these)
    [C_, m_ ] = these(i).par2gauss;
    gs(i) = cpdf( gk(C_, m_ ) );
    gss(i) = ( gs(i) )^(1/length(these)) ;
end

multgs = gss(1);
for i=2:length(these);
    multgs = multgs*( gss(i) );
end

s = gk2gmm( cpdf(multgs) );

% sample from the proposal
pts = s.gensamples( these(1).getnumpoints*length(these)*osfactor );
% find the weights at the denom
ws = s.evaluate( pts );

% find the log weights at the numerator
lwp = zeros(size(ws));
for i=1:length(these)
    % Find the contribution of the ith element
    ei =  these(i).evaluate( pts, 'threshold', -1000 );   
    % To have some non-zero but small values at the tails,
    % give a raise to very small values
    %ei = condeval( ei);
    lwi = log( ei ) ;
    lwp = lwp + lwi;
end
% Make the division in the log domain
lw_is = condlog( lwp - log(ws) );
%lw_is = ( lwp - log(ws) );
w_is = exp( lw_is - max(lw_is) );
w_is = w_is/sum(w_is);

N_eff = 1/sum(w_is.^2);
if N_eff<max( size(pts,1) );
    disp(sprintf('Particle defficiency in the product IS weights, N_eff = %g',N_eff));
    w_is = w_is + 0.01;
    w_is = w_is/sum(w_is);
    N_eff = 1/sum(w_is.^2);
   disp(sprintf('Improved to N_eff = %g',N_eff));
end
 

idx = resample( w_is, floor( length(w_is)/length(these)/osfactor ) );

res = particles('states',pts(:,idx),'labels',these(1).labels);
res.findkdebws('nonsparse');

end
function l = condlog(inp)
% This function conditions log values so that we don't have any -Inf
ind = find( inp ~= -Inf );
minval = min( inp( ind ) );
if isempty( minval )
    % all are -Inf
    l = zeros( size( inp ) );
else
ind = find( inp == -Inf );
inp(ind) = minval-100;
l = inp;
end
end
function ei = condeval( ei )
ind = find(ei<1.0e-66 );
ind2 = setdiff( [1:length(ei)], ind );

ei( ind ) = min( ei(ind2) );

% maxval = max(ei);
% th = maxval*min(1/( length(ei) ), 1.0e-4);
% ind = find(ei<=th);
% if ~isempty(ind)
%     ei(ind) = th;
% end
end



