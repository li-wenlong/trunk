function [ ll , pz ] = paramlhood(  f, sen, th, Zs )
% function [ ll , pz ] = paramlhood(  f, sen, th, Zs )
% returns the latent parameter likelihood through the target process given
% a filter object f, S sensor objects in sen, 
% N parameter vectors in [dxN] array th, and the (multi
% sensor) measurements Zs which is an [TxS] sreport array where T is the 
% length of the time window and S is the number of sensors
% ( Currently, th are location parameters of dimension (S-1)*2)
% 

[ d, N ] = size(th);
[ T,S ] =  size(Zs);
ll = zeros(1,N);
pz = zeros(T,N);

for k=1:N % For each param value
    
    % Pick the location parameters
    theta_xy = reshape( th(:,k)',d/(S-1),S-1);
    
    % Now find the likelihood based on the time window of lenght T
    filterObj = f;
    for t=1:T
        filterObj.Z = Zs( t,:);
        filterObj.onestep( sen, theta_xy );
        lval = filterObj.parlhood(end) ; % likelihood value
        
        pz(t,k) = lval;        
    end
    ll(k) = sum( log( pz(:,k) ) );
end
    



