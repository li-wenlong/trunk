
function [s_post, mu_post, d_quad, quad_i_bound_condkld, quad_h_bound ] = fun_AR1MarkovChain_paramestquadterm( sig_ni, mu_ni , sig_nj , mu_nj, ...,
    sig_x1, mu_x1, a, sig_v, mu_v, sig_theta , mu_theta, t )

% This script is for numerically finding information quantities
% regarding the manipulations of the following AR-1 Markov
% Chain for k=1,...,t and estimation of an unknown parameters theta:
% x_k = a x_km1 + v_k
% with v_k ~ N(.;0,sig_v), x1 ~ N(.;0,sig_x1)
% zi_k = x_k + ni_k
% zj_k = x_k + theta + nj_k
% with ni_k ~ N(.;0,sig_ni) and nj_k ~ N(.;0,sig_nj)
% and theta is an unknown variable which has a priori distribution N(.;mu_theta,sig_theta)
% For now; mu_theta = 0 is assumed


% construct mu_x
mu_x = [mu_x1];
for i=2:t
    mu_x = [ mu_x; mu_x(end)*a + mu_v ];
end

mu_xninj    = [ mu_x; mu_ni*ones(t,1); mu_nj*ones(t,1) ];
mu_xbarninj = [ mu_theta ;mu_x; mu_ni*ones(t,1); mu_nj*ones(t,1) ];

theta_ind = 1;
x_ind = theta_ind(end) + [1:t];
zi_ind = x_ind(end) + [1:t];
zj_ind = zi_ind(end) + [1:t];

% Now, construct C_x in accordance with the AR1 Markov chain 
% x_1 ~ N(.;0,sig_x1 )
% x_k = a x_km1 + v_k for k=2,...,t
% with v_k ~ N(.;0,sig_v)
A = fliplr( hankel([ zeros(1,t-2) 1 -a] ) );
A = A(1:end-1,:);

C_x_inv =  transpose(A)*( eye(t-1)*(1/sig_v^2) )*A ;
C_x_inv(1) = C_x_inv(1) + 1/sig_x1^2 ;

% Now, construct C_xbarninj
C_all_inv = blkdiag( (1/sig_theta^2), C_x_inv, eye(t)*(1/sig_ni^2), eye(t)*(1/sig_nj^2) );

T = blkdiag( 1, eye(t), eye(t), eye(t) );

Hi = eye(t);
Hibar = [zeros(t,1), Hi ];
Hj = eye(t);
Hjbar = [ones(t,1), Hj ];

T(t+1+1:t+1+t,1:t+1) = -Hibar;
T(t+1+t+1:t+1+t+t,1:t+1) = -Hjbar;

% Now, find C_joint = C_xbarzizj
C_joint_inv = transpose(T)*C_all_inv*T;
mu_joint = inv(T)*mu_xbarninj;

dim = size( C_joint_inv , 2 );

nu_xbarninj = C_joint_inv*mu_joint;

%K_xbarzizj = ( 1/( (2*pi)^(dim/2)* sqrt(det( inv(C_joint_inv)) )   ));
% p_xbarzizj = K_xbarzizj*exp( -0.5*transpose( xall )*( C_joint_inv  )*xall );

R = chol(C_joint_inv);
Rinv = R^(-1);

C_joint = Rinv*Rinv';

%p_joint = gk( C_joint, mu_xbarninj ); 

%p_thetazizj =  p_joint.marginalise( setdiff( [1:dim]  ,[2:2+t-1] ) );
%p_thetaGzizj = p_thetazizj.conditional(1);

% Marginalise x_{1:t} from the joint
% This is the joint p(theta, zi, zj )
[ C_thetazizj, mu_thetazizj ] = gaussmarg(C_joint, [theta_ind, zi_ind,zj_ind], mu_joint );


% This is p(theta | zi, zj )
zi_indh = zi_ind - (x_ind(end)-x_ind(1)+1);
zj_indh = zj_ind - (x_ind(end)-x_ind(1)+1);
[C_thetaGzizj, mu_thetaGzizj, a_thetaGzizj, B_thetaGzizj   ] = gausscond( C_thetazizj, [zi_indh, zj_indh], mu_thetazizj  );


% This is p( zi, zj | theta )
[C_zizjGtheta , mu_zizjGtheta, a_zizjGtheta, B_zizjGtheta   ] = gausscond( C_thetazizj, [1] , mu_thetazizj );


% Construct the joint model for the quad term separable likelihood
for k=2:t
    % For the joint update
    % Find p( z^i_k, z^j_k, z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    % bu marginalising out from the joint model C_joint
    zs_ind = [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_zszizj, mu_zszizj] = gaussmarg( C_joint, zs_ind, mu_joint );
    % Find the posterior p(\theta | z^i_{1:k}, z^j_{1:k})
    [ C_post, mu_post ] = gausscond( C_zszizj, [2:length(zs_ind)], mu_zszizj  );
    s_post(k) = C_post;
    m_post(k) = mu_post;
    
    % Find p( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    zi_hist = [4:4-1+k-1];
    if isempty( zi_hist )
        zj_hist = zi_hist;
    else
        zj_hist = [zi_hist(end)+1:zi_hist(end)+k-1];
    end
    [ C_zsGzizj, mu_zsGzizj, a_zsGzizj, B_zsGzizj ] = gausscond( C_zszizj, [1,zi_hist,zj_hist], mu_zszizj  );
    % Find the conditional as a quadratic exponential
    [ C_j, L_j ] = gausscondquad( C_zszizj,  [1,zi_hist,zj_hist]  );
    
    
    % For the quad-term update
    % Find p( z^i_k, z^j_k, z^i_{1:k-1},\theta)
    [ C_zszi, mu_zszi ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1) ], mu_joint );
    % Find p( z^i_k, z^j_k | z^i_{1:k-1},\theta)
    [ C_zsGzi, mu_zsGzi, a_zsGzi, B_zsGzi  ] = gausscond( C_zszi, [1,[4:4-1+k-1]] , mu_zszi );
    % above conditional
    % in quadratic exponential form
    [ C_1, L_1 ] = gausscondquad( C_zszi, [1,[4:4-1+k-1]] );
    
    % Find p( z^i_k, z^j_k, z^j_{1:k-1},\theta)
    [ C_zszj, mu_zszj ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k),zj_ind(k),zj_ind(1:k-1) ] , mu_joint );
    % Find  p( z^i_k, z^j_k| z^j_{1:k-1},\theta)
    [ C_zsGzj, mu_zsGzj, a_zsGzj, B_zsGzj  ] = gausscond( C_zszj, [1,[4:4-1+k-1]], mu_zszj );
    % above conditional 
    % in quadratic exponential form
    [ C_2, L_2 ] = gausscondquad( C_zszj, [1,[4:4-1+k-1]] );
    
    % Take the EMD for w=0.5
    
    [ C_quadup, a_quadup, B_quadup  ] = emdocond( C_zsGzi, a_zsGzi, B_zsGzi, C_zsGzj, a_zsGzj, B_zsGzj , 0.5, [1] );
    
    % Find the KLD of the conditionals
    
    % Find the prior for theta, zi_hist, zj_hist
    % i.e., p( z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    prior_ind = [theta_ind, zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_prior, mu_prior] = gaussmarg( C_joint, prior_ind, mu_joint );
    
    d_quad(k) = gkldcond( C_prior, mu_prior,  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_quadup, a_quadup, B_quadup);
  
end



% Compute the upper bound given in terms of mutual information terms
for k=1:t
    % For the joint update
    % Find p( z^i_k, z^j_k, z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    zs_ind = [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_zszizj, mu_zszizj] = gaussmarg( C_joint, zs_ind, mu_joint );
    
      
    % Find p( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    zi_hist = [4:4-1+k-1];
    if isempty( zi_hist )
        zj_hist = zi_hist;
    else
        zj_hist = [zi_hist(end)+1:zi_hist(end)+k-1];
    end
    [ C_zsGzizj, mu_zsGzizj, a_zsGzizj, B_zsGzizj ] = gausscond( C_zszizj, [1,zi_hist,zj_hist], mu_zszizj  );
    % Find the conditional as a quadratic exponential
    [ C_j, L_j ] = gausscondquad( C_zszizj,  [1,zi_hist,zj_hist]  );
    
    
    % Find p( z^i_k, z^j_k, z^i_{1:k-1},\theta)
    [ C_zszi, mu_zszi ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1) ], mu_joint );
    % Find p( z^i_k, z^j_k | z^i_{1:k-1},\theta)
    [ C_zsGzi, mu_zsGzi, a_zsGzi, B_zsGzi  ] = gausscond( C_zszi, [1,[4:4-1+k-1]] , mu_zszi );
    % above conditional
    % in quadratic exponential form
    [ C_1, L_1 ] = gausscondquad( C_zszi, [1,[4:4-1+k-1]] );
    
    % Find p( z^i_k, z^j_k, z^j_{1:k-1},\theta)
    [ C_zszj, mu_zszj ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k),zj_ind(k),zj_ind(1:k-1) ] , mu_joint );
    % Find  p( z^i_k, z^j_k| z^j_{1:k-1},\theta)
    [ C_zsGzj, mu_zsGzj, a_zsGzj, B_zsGzj  ] = gausscond( C_zszj, [1,[4:4-1+k-1]], mu_zszj );
    % above conditional 
    % in quadratic exponential form
    [ C_2, L_2 ] = gausscondquad( C_zszj, [1,[4:4-1+k-1]] );
    
    i1 = gentropy( C_zsGzj) - gentropy(C_zsGzizj );
    i2 = gentropy( C_zsGzi  ) - gentropy(C_zsGzizj );
    
    quad_i_bound(k) = (i1 + i2)/2;
    
    
    if k == 1
        continue;
    end
    
    % Find the I bound
    
    % Find H( X|Y) = H(X,Y) - H(Y) terms
    [ C_zj, mu_zj ] =  gaussmarg( C_joint, [theta_ind, zj_ind(1:k-1) ] , mu_joint );
    [ C_zi, mu_zi ] =  gaussmarg( C_joint, [theta_ind, zi_ind(1:k-1) ] , mu_joint );
    [ C_zizjhist, mu_zizjhist ] =  gaussmarg( C_joint, [theta_ind, zi_ind(1:k-1),zj_ind(1:k-1) ] , mu_joint );
    
    H1A = gentropy( C_zszj ) - gentropy( C_zj ); % H( z^i_k, z^j_k | z^j_{1:k-1}, theta)
 
    H1B = gentropy( C_zszizj ) - gentropy( C_zizjhist );  % H( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1}, theta ) 
    
    % H1A - H1B = I(z^i_k, z^j_k; z^i_{1:k-1} | z^j_{1:k-1}, theta )
    
    H2A = gentropy( C_zszi ) - gentropy( C_zi );% H( z^i_k, z^j_k | z^i_{1:k-1}, theta )
    
    H2B = gentropy( C_zszizj ) - gentropy( C_zizjhist ); % H( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1}, theta )
    
    i1 = H1A - H1B;
    
    i2 = H2A - H2B;
    
    quad_i_bound_hdiff(k) = (i1 + i2)/2;
    
    %%
    % Find the I bound using D( p( x, y | z ) || p( x | z )p( y | z ) )
    % Note that, this is valid for k>=2 since otherwise the variables 
    % z^i_{1:k-1} and z^j_{1:k-1} do not exist
    
    
    
    % Find p( z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    % by marginalising out from the joint model C_joint
    var_ind = [theta_ind, zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_zhist, mu_zhist] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % Find  p( z^i_{1:k-1} | z^j_{1:k-1} , \theta) - p(y|z) bit
    zi_hist2 = 1+[1:k-1];
     if isempty( zi_hist2 )
        zj_hist2 = [];
    else
        zj_hist2 = [zi_hist2(end)+1:zi_hist2(end)+ k-1];
     end 
    [ C_zihGzjh, mu_zihGzjh, a_zihGzjh, B_zihGzjh ] = gausscond( C_zhist, [1,zj_hist2], mu_zhist  );
    
       
    % Multiply p( x | z) with p( y | z)
    % Find p(z^i_k, z^j_k | z^j_{1:k-1}, theta )p( z^i_{1:k-1} | z^j_{1:k-1}, theta ))
    [C_denom, a_denom, B_denom ] = multocond( C_zsGzj, a_zsGzj, B_zsGzj, C_zihGzjh , a_zihGzjh, B_zihGzjh   );
    
    % Find p(x,y|z)
    % Find p( z^i_k, z^j_k  z^i_{1:k-1} | z^j_{1:k-1} , \theta)
    [ C_num, mu_num, a_num, B_num ] = gausscond( C_zszizj, [1,zj_hist], mu_zszizj  );
    
    % Find the prior
    % i.e., p( z^j_{1:k-1} , \theta)
    prior_ind = [theta_ind, zj_ind(1:k-1)];
    [ C_prior, mu_prior] = gaussmarg( C_joint, prior_ind, mu_joint );
    
    i1 = gkldcond(C_prior,mu_prior,C_num,a_num, B_num, C_denom, a_denom, B_denom  );
    
    
    % Now, the second I term:
     % Find  this time p( z^j_{1:k-1} | z^i_{1:k-1} , \theta) - p(y|z) bit
    [ C_zjhGzih, mu_zjhGzih, a_zjhGzih, B_zjhGzih ] = gausscond( C_zhist, [1,zi_hist2], mu_zhist  );
    
    % Multiply p( x | z) with p( y | z)
    % Find p(z^i_k, z^j_k | z^i_{1:k-1}, theta )p( z^j_{1:k-1} | z^i_{1:k-1}, theta ))
    [C_denom, a_denom, B_denom ] = multocond( C_zsGzi, a_zsGzi, B_zsGzi, C_zjhGzih , a_zjhGzih, B_zjhGzih );
    
    % Find p(x,y|z)
    % Find p( z^i_k, z^j_k  z^j_{1:k-1} | z^i_{1:k-1} , \theta)
    [ C_num, mu_num, a_num, B_num ] = gausscond( C_zszizj, [1,zi_hist], mu_zszizj  );
    
    % Find the prior
    % i.e., p( z^i_{1:k-1} , \theta)
    prior_ind = [theta_ind, zi_ind(1:k-1)];
    [ C_prior, mu_prior] = gaussmarg( C_joint, prior_ind, mu_joint );
    
     i2 = gkldcond(C_prior,mu_prior,C_num,a_num, B_num, C_denom, a_denom, B_denom  );
      
     quad_i_bound_condkld(k) = (i1 + i2)/2;
     
     
end


%% Compute the upper bound given in terms of entropies of prediction and estimation 
% of the filters
for k=1:t
    
    %% At sensor i
    % Find the time posterior
    % 1) Find p( x_k , z^i_{1:k} )
    var_ind = [x_ind(k), zi_ind(1:k)];
    [ C_xzi, mu_xzi ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k} )
    [ C_xGzi, mu_xGzi, a_xGzi, B_xGzi ] = gausscond( C_xzi, [2:length(mu_xzi)], mu_xzi  );
    
    
    % Find the time prediction
    % 1) Find p(  x_k , z^i_{1:k-1}  ) 
    var_ind = [x_ind(k), zi_ind(1:k-1)];
    [ C_xzihist, mu_xzihist ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k-1} )
    if k==1
        C_xGzihist = C_xzihist;
        mu_xGzihist = mu_xzihist;
    else
        [ C_xGzihist, mu_xGzihist, a_xGzihist, B_xGzihist ] = gausscond( C_xzihist, [2:length(mu_xzihist)], mu_xzihist  );
    end
    
     %% At sensor j
    % Find the time posterior
    % 1) Find p( x_k , z^j_{1:k} )
    var_ind = [x_ind(k), zj_ind(1:k)];
    [ C_xzj, mu_xzj ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^j_{1:k} )
    [ C_xGzj, mu_xGzj, a_xGzj, B_xGzj ] = gausscond( C_xzj, [2:length(mu_xzj)], mu_xzj  );
    
    % Find the time prediction
    % 1) Find p(  x_k , z^j_{1:k-1}  ) 
    var_ind = [x_ind(k), zj_ind(1:k-1)];
    [ C_xzjhist, mu_xzjhist ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k-1} )
    if k==1
        C_xGzjhist = C_xzjhist;
        mu_xGzjhist = mu_xzjhist;
    else
        [ C_xGzjhist, mu_xGzjhist, a_xGzjhist, B_xGzjhist ] = gausscond( C_xzjhist, [2:length(mu_xzjhist)], mu_xzjhist  );
    end
    
    %% At the centre with access to the data from sensors i and j  
    % Find the time posterior
    % 1) Find p( x_k , z^i_{1:k}, z^j_{1:k} )
    var_ind = [x_ind(k), zi_ind(1:k), zj_ind(1:k)];
    [ C_xzizj, mu_xzizj ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k}, z^j_{1:k} )
    [ C_xGzizj, mu_xGzizj, a_xGzizj, B_xGzizj ] = gausscond( C_xzizj, [2:length(mu_xzizj)], mu_xzizj  );
    
    % Find the time prediction
    % 1) Find p(  x_k ,  z^i_{1:k-1} , z^j_{1:k-1}  ) 
    var_ind = [x_ind(k),  zi_ind(1:k-1) , zj_ind(1:k-1)];
    [ C_xzizjhist, mu_xzizjhist ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k-1} , z^j_{1:k-1}  )
    if k==1
        C_xGzizjhist = C_xzizjhist;
        mu_xGzizjhist = mu_xzizjhist;
    else
        [ C_xGzizjhist, mu_xGzizjhist, a_xGzizjhist, B_xGzizjhist ] = gausscond( C_xzizjhist, [2:length(mu_xzizjhist)], mu_xzizjhist  );
    end
    
    % Find  p( x_k | z^i_k, z^i_{1:k-1} , z^j_{1:k-1}  )
    var_ind = [x_ind(k), zi_ind(1:k), zj_ind(1:k-1)];
    [ C_xzik_allhist, mu_xzik_allhist ] = gaussmarg( C_joint, var_ind, mu_joint );
    [ C_xGzik_allhist, mu_xGzik_allhist, a_xGzik_allhist, B_xGzik_allhist ] = gausscond( C_xzik_allhist, [2:length(mu_xzik_allhist)], mu_xzik_allhist  );
    
    % Find  p( x_k | z^j_k, z^i_{1:k-1} , z^j_{1:k-1}  )
    var_ind = [x_ind(k), zi_ind(1:k-1), zj_ind(1:k)];
    [ C_xzjk_allhist, mu_xzjk_allhist ] = gaussmarg( C_joint, var_ind, mu_joint );
    [ C_xGzjk_allhist, mu_xGzjk_allhist, a_xGzjk_allhist, B_xGzjk_allhist ] = gausscond( C_xzjk_allhist, [2:length(mu_xzjk_allhist)], mu_xzjk_allhist  );
    
    %% Find the H bounds
    Hjpred = gentropy( C_xGzjhist );
    Hcpred = gentropy( C_xGzizjhist );
    Hipred = gentropy( C_xGzihist );
    
    
    Hjpost = gentropy( C_xGzj );
    Hipost = gentropy( C_xGzi );
    Hcpostzj = gentropy( C_xGzjk_allhist );
    Hcpostzi = gentropy( C_xGzik_allhist );
    
    quad_h_bound(k) = 0.5*( Hjpred - Hcpred + Hipred - Hcpred ) + 0.5*( Hjpost - Hcpostzj + Hipost - Hcpostzi  );
    
     
end


