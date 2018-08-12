function [rpCI varargout] = kdeci_kde(p1,w1,p2,w2,omegaList )
% kdeci_kde(p1,w1,p2,w2,omega);
% particles: p1, p2 [Ndim X N1] and [Ndim X N2]
% weights: w1,  w1 [1 X N1] and [1 X N2]
%


ent1 = sum(w1);
ent2 = sum(w2);

[dummy_1 dummy_2] = size(p1);
if dummy_1>dummy_2
    p1 = p1';
end

[dummy_1 dummy_2] = size(p2);
if dummy_1>dummy_2
    p2 = p2';
end


[d N1] = size(p1);
[d N2] = size(p2);

w1 = reshape( w1, 1, N1);
w2 = reshape( w2, 1, N2);

% Find the whitening transforms
C_p = cov(p1');
% Find the inverse covariance
R = chol(C_p);
Rinv = R^(-1); 
Lambda_p = Rinv*Rinv';


Wp = sqrtm(Lambda_p);% The whitening trasform


C_q = cov(p2');
% Find the inverse covariance
R = chol(C_q);
Rinv = R^(-1); % The whitening trasform
Lambda_q = Rinv*Rinv';

Wq = sqrtm( Lambda_q );% The whitening trasform

% Construct the kde objects
opt = kde( Wp*p1, 'rot', w1, 'g' ); % Weights are scaled at constructor
oqt = kde( Wq*p2, 'rot', w2, 'g' ); % Weights are scaled at constructor

% Find the bandwidths and assign to the kde objects
if d == 2
    A = 0.96;
else
    A = (4/(2*d+1))^(1/(d+4)); 
end
h1 = A*N1^(-1/(d+4));
h2 = A*N2^(-1/(d+4));


opt = ksize( opt, h1 );
oqt = ksize( oqt, h2 );

p_kde = [p1,p2];
N = size( p_kde, 2);

v1_kde = evaluate( opt, Wp*p_kde  );
v2_kde = evaluate( oqt, Wq*p_kde  );

% v1_kde = v1_kde*h1^(-d)*(2*pi)^(-d/2)*det(C_p)^(-1/2);
% v2_kde = v2_kde*h2^(-d)*(2*pi)^(-d/2)*det(C_q)^(-1/2);

rpCI = {}; %List storing resampled Particles
weigtsCI = {}; % List storing weights

inp1 = kde( p1, 'rot', w1, 'g' );
inp2 = kde( p2, 'rot', w2, 'g' );
infomeasures.h1 = entropy( inp1 );
infomeasures.kld1to2  = kld(inp1,inp2);
infomeasures.kld2to1 = kld(inp2, inp1);
infomeasures.h2 = entropy( inp2 );

for omegaCnt = 1:length(omegaList)
    omega = omegaList(omegaCnt);
    % Compute the weights corresponding to p1
    ww_f = (v1_kde(1:N1).^(-omega) ).*( v2_kde(1:N1).^(omega) ).*w1;
   % ww_f = ww_f/sum(ww_f);

    % Compute the weights corresponding to p2
    ww_g = ( v1_kde(N1+1:N1+N2).^(1-omega) ).*( v2_kde(N1+1:N1+N2).^(omega-1) ).*w2;
   % ww_g = ww_g/sum(ww_g);
    % Combine the two
    ww_kde = [ww_f,ww_g]/2;
    ww_kde_Scaled = ww_kde/sum(ww_kde);

    
    idx= resample(ww_kde_Scaled, N);
    pp_kde = p_kde(:,idx);
        
    rpCI{omegaCnt} = pp_kde;
    weigtsCI{omegaCnt} = ww_kde_Scaled;
    
    pomega = kde( pp_kde, 'rot',ww_kde_Scaled ,'g');
    
    Iests(omegaCnt) = ( kld(pomega,inp1)-kld(pomega,inp2) )^2;
end

if nargout>1
    varargout{1} = weigtsCI;
end
if nargout>2
    
%     % Extract the emprical scale factor for v1
%     diffVect = (p1-repmat(p1(:,1),1,N1));
%     beta = sum( diffVect.*(Lambda_p*diffVect) );
%     v1_p11 = sum( w1.*exp( -beta/(2*h1*h1)) );
% 
%     v1_p11_scaleFactor = sum(w1)^(-1)*h1^(-d)*(2*pi)^(-d/2)*det(C_p)^(-1/2);
%     v1_p11sc = v1_p11*v1_p11_scaleFactor;
% 
%     % Scale v1_kde so that it is equal to p evaluated at p1 and p2
%     v1_kde_sc = v1_kde*v1_p11sc(1)/v1_kde(1);
% 
%     % Extract the emprical scale factor for v2
%     diffVect = (p2-repmat(p2(:,1),1,N2));
%     beta = sum( diffVect.*(Lambda_q*diffVect) );
%     v2_p21 = sum( w2.*exp( -beta/(2*h2*h2)) );
% 
%     v2_p21_scaleFactor = sum(w2)^(-1)*h2^(-d)*(2*pi)^(-d/2)*det(C_q)^(-1/2);
%     v2_p21sc = v2_p21*v2_p21_scaleFactor;
% 
%     % Scale v2_kde so that it is equal to q evaluated at p1 and p2
%     v2_kde_sc = v2_kde*v2_p21sc(1)/v2_kde(N1+1);
% 
%     Iests = [];
%     % Estimate the integral of p^(1-w)q^w
%     for omegaCnt = 1:length(omegaList)
%         omega = omegaList(omegaCnt);
%         
%         If = (1/sum(w1))*sum( w1.*( v1_kde_sc(1:N1).^(-omega).*v2_kde_sc(1:N1).^omega   )  );
% 
%         Ig = (1/sum(w2))*sum( w2.*( v1_kde_sc(N1+1:N1+N2).^(1-omega).*v2_kde_sc(N1+1:N1+N2).^(omega-1) ) );
% 
%         Iest = (If*N1+Ig*N2)/(N1+N2);
% 
%         Iests(omegaCnt) = Iest;
%     end
    varargout{2} = Iests;

end
 if nargout>3
     varargout{3} = infomeasures;
 end

%pp = regularise(pp);

%-------------------------------------------------------------------
function resample_idx= resample(w,L)
% resampling 
% function resample_idx= resample(w,L)
% w- the weights with sum(w)= 1
% L- no. of samples you want to resample
% resample_idx- indices for the resampled particles

resample_idx= [];
[notused,sort_idx]= sort(-w);   %sort in descending order
rv= rand(L,1);
i= 0; threshold= 0;
while ~isempty(rv),
    i= i+1; threshold= threshold+ w(sort_idx(i));
    rv_len= length(rv);
    idx= find(rv>threshold); 
    resample_idx= [ resample_idx; sort_idx(i)*ones(rv_len-length(idx),1) ];
    rv= rv(idx);
end;
%-----------------------------------------------------------------
function py = regularise(px)
%
xdim = 4;
py = px;
[nx Np] = size(px);
% this is nx=4 only
A = (4/(nx+2))^(1/(nx+4));
h_fact =  A * Np^(-1/(nx+4));
C = cov(px');
if rcond(C)>eps
            %Am = sqrtm(C);
   Am = chol(C)';
else
            %disp('Problem with sqrtm in C matrix');
   Am = 0.00001*eye(xdim); 
end    
if ~isreal(Am)
    Am = 0.00001*eye(xdim);
end     
Am = chol(C)';
gauss_mat = randn(nx,Np);

py = px + 0.1*h_fact * Am *gauss_mat;