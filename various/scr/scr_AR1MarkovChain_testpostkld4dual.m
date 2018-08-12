% This script is for numerically testing information quantities re
% the following AR-1 Markov
% Chain for k=1,...,t and estimation of an unknown parameters theta:
% x_k = a x_km1 + v_k
% with v_k ~ N(.;0,sig_v), x1 ~ N(.;0,sig_x1)
% zi_k = x_k + ni_k
% zj_k = x_k + theta + nj_k
% with ni_k ~ N(.;0,sig_ni) and nj_k ~ N(.;0,sig_nj)
% and theta is an unknown variable which has a priori distribution N(.;mu_theta,sig_theta)
% For now; mu_theta = 0 is assumed


sig_ni = 1;
mu_ni = 0;

sig_nj = 1;
mu_nj = 0;

sig_x1 = 1;
mu_x1 = 0;

sig_v = 0.5;
mu_v = 0;

a = 1; 

sig_theta = 5;
mu_theta = 0;




t = 100; % This is the length of the time window

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


% Construct the joint model for the dual term separable likelihood
for k=1:t
    fprintf('%d,',k);
    if mod(k,40)==0
        fprintf('\n');
    end
    % For the joint update
    % Find p( z^i_k, z^j_k, z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    % bu marginalising out from the joint model C_joint
    zs_ind = [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_zszizj, mu_zszizj] = gaussmarg( C_joint, zs_ind, mu_joint );
    
    
   
    zi_hist = [4:4-1+k-1]; % 1: theta 2: z^i_k 3: z^j_k
    if isempty( zi_hist )
        zj_hist = zi_hist;
    else
        zj_hist = [zi_hist(end)+1:zi_hist(end)+k-1];
    end
    % Find p( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    [ C_zsGzizj, mu_zsGzizj, a_zsGzizj, B_zsGzizj ] = gausscond( C_zszizj, [1,zi_hist,zj_hist], mu_zszizj  );
    
    % For the dual-term update
    % Find p( z^j_k, z^i_{1:k-1},\theta)
    [ C_zjzihist, mu_zjzihist ] =  gaussmarg( C_joint, [theta_ind, zj_ind(k), zi_ind(1:k-1)], mu_joint );
    % Find p( z^j_k | z^i_{1:k-1},\theta)
    [ C_zjGzi, mu_zjGzi, a_zjGzi, B_zjGzi  ] = gausscond( C_zjzihist, [1,[3:3-1+k-1]] , mu_zjzihist );
    
    % Find p( z^i_k, z^j_{1:k-1},\theta)
    [ C_zizjhist, mu_zizjhist ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k),zj_ind(1:k-1) ] , mu_joint );
    % Find  p( z^i_k | z^j_{1:k-1},\theta)
    [ C_ziGzj, mu_ziGzj, a_ziGzj, B_ziGzj  ] = gausscond( C_zizjhist, [1,[3:3-1+k-1]], mu_zizjhist );
    
    % Multiply  p( z^i_k | z^j_{1:k-1},\theta) with p( z^j_k | z^i_{1:k-1},\theta)
    % Below, the order of terms are as follows (  z^i_k | \theta z^j_{1:k-1} , z^i_{1:k-1} )
    [C_dual, a_dual, B_dual ] = multfordual( C_ziGzj, a_ziGzj, B_ziGzj, C_zjGzi , a_zjGzi, B_zjGzi );
    % the order of the arguments in the given bit is \theta z^j_{1:k-1},
    % z^i_{1:k-1} make it \theta, z^i, z^j
    B_dual = B_dual(:,[1, [2+k-1:2+k-1+k-1-1] ,[2:2+k-1-1]]);
    
    
    % Find the KLD of the conditionals
    
    % Find the prior for theta, zi_hist, zj_hist
    % i.e., p( z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    prior_ind = [theta_ind, zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_prior, mu_prior] = gaussmarg( C_joint, prior_ind, mu_joint );
    
    d_dual(k) = gkldcond( C_prior, mu_prior,  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_dual, a_dual, B_dual);
    
   
    %% Compute KLD using
    % D(p(x|y)|| q(x|y) ) =  D( p(x,y)|| q(x,y) ) - D( p(y) || q(y) ) and
    % the last term is zero since p(y)= q(y) in our case.
    
    % Multiply s( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} ) and p( \theta, z^i_{1:k-1}, z^j_{1:k-1} )
    % get s( z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1} )
   [ C_sj, mu_sj ] = multocondwprior(  C_dual, a_dual, B_dual, C_prior, mu_prior );
   [ C_sj, mu_sj ] = gordervar( C_sj, [3 1 2 [4:length(mu_sj)]] , mu_sj );
    
    [ C_pj2, mu_pj2 ] = multocondwprior(  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_prior, mu_prior );
    [ C_pj3, mu_pj3 ] = gordervar( C_pj2, [3 1 2 [4:length(mu_sj)]] , mu_pj2 );
    
    % Note that D( p( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} ) || s( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} )  ) =
    % D( p(z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1})|| s(z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1}) ) - D( prior() || prior() ) 
    % as we use the same prior() in the joints p() and q(): 
    d_dual2(k) = gkld( C_pj3, C_sj, mu_pj3, mu_sj  );
    
    %% AS a by-product on the way,  
    % find the KLD D( p( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1})  || s(z^i_k, z^j_k| z^i_{1:k-1}, z^j_{1:k-1})   )
    
    % Marginalize \theta out from the joint
    [C_szj, mu_szj] = gaussmarg(C_sj, [2:length(mu_sj)] , mu_sj );
    % Find the conditional 
    [C_szjcond, mu_szjcond, a_szjcond, B_szjcond ] = gausscond(C_szj, [3:length(mu_szj)] ,mu_szj );
    
    % Similarly marginalise out \theta
    [C_pzj, mu_pzj] = gaussmarg(C_pj3, [2:length(mu_pj3)] , mu_pj3 );
    [C_pzjcond, mu_pzjcond, a_pzjcond, B_pzjcond ] = gausscond(C_pzj, [3:length(mu_pzj)] ,mu_pzj );
    
    [C_pr, mu_pr ] = gaussmarg( C_prior, [2:length(mu_prior)], mu_prior );
    
    d_pz2sz(k) =  gkldcond( C_pr, mu_pr,  C_pzjcond, a_pzjcond, B_pzjcond, C_szjcond, a_szjcond, B_szjcond); 
    
    % This one produces the same result with the line above
    d_pz2sz2(k) = gkld( C_pzj, C_szj, mu_pzj, mu_szj );%
    
    
    
    
    %% Now, lets continue finding the KLD for the posteriors
    
    % Now, test the likelihood update function
    
    % The function below uplhood1d does not work, the maths needs to be
    % worked out again and verified.
%     % The below update works?
%     if k==1
%        C_l =  C_zsGzizj; a_l = a_zsGzizj; B_l = B_zsGzizj;
%     else
%         [C_l, a_l, B_l] = uplhood1d( C_zsGzizj, a_zsGzizj, B_zsGzizj, C_l, a_l, B_l );
%     end
    
    % Compare with the likelihood found below
    % p(z^i_{1:k}, z^j_{1:k} | \theta )
    
    % Find p(\theta, z^i_{1:k}, z^j_{1:k} )
    % bu marginalising out from the joint model C_joint
    zs_ind = [theta_ind, zi_ind(1:k), zj_ind(1:k)];
    [ C_kj, mu_kj] = gaussmarg( C_joint, zs_ind, mu_joint );
    [ C_lhood, mu_lhood, a_lhood, B_lhood ] = gausscond( C_kj, [1], mu_kj  );
    
    % Below, the likelihood is constructed with the alternative approach
    % that will be used for constructing \tilde l()
    if k==1
        C_l =  C_zsGzizj; a_l = a_zsGzizj; B_l = B_zsGzizj;
    else
        % Below, we find p(z^i_1,...,z^i_{k-1}, z^j_1,...,z^j_{k-1}, \theta )
        % with the product:
        % l(z^i_1,...,z^i_{k-1}, z^j_1,...,z^j_{k-1}|\theta) x p( \theta )
        [ C_lj, mu_lj ] = multocondwprior(  C_l, a_l, B_l, sig_theta^2, mu_theta );
        % This is the joint model implied with the likelihood stored in  C_l, a_l, B_l
        
        % Use this as a prior for the current update and find
        % the joint involving the update term
        
        % i) reorder terms as \theta, z^i_{1:k-1} z^j_{1:k-1}
        [ C_ljre, mu_ljre ] = gordervar( C_lj, [length(mu_lj),[1:length(mu_lj)-1]], mu_lj );
        % ii) multiply p( z^i_k, z^j_k |\theta, z^i_{1:k-1}, z^j_{1:k-1} , )
        % with p( \theta, z^i_{1:k-1} z^j_{1:k-1} )
        [ C_lje, mu_lje ] = multocondwprior(  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_ljre, mu_ljre );
        % iii) order from z^i_k, z^j_k, \theta, z^i_{1:k-1}, z^j_{1:k-1}
        % to \theta z^i_{1:k-1} z^i_k z^j_{1:k-1}, z^j_{k}
        
        [ C_lje, mu_lje ] = gordervar( C_lje, [3,zi_hist,1,zj_hist,2] , mu_lje );
        % Now, given this joint, find the conditional given theta as the
        % updated likelihood
        [ C_l, mu_dummy, a_l, B_l ] = gausscond( C_lje, [1], mu_lje  );
        
        % Now, using the joint, find the conditional given the measurements
        % which is the posterior
        [ C_postp, mu_dummy, a_postp, B_postp ] = gausscond( C_lje, [2:length(mu_lje)], mu_lje  );
        
        % Find p(z^i_{1:k}, z^j_{1:k})
        [ C_pzs, mu_pzs] = gaussmarg( C_lje, [2:length(mu_lje)], mu_lje );
   
        
    end
    
    
    %% Below, \tilde l() is found
    if k==1
        C_tl =  C_dual; a_tl = a_dual; B_tl = B_dual;
    else
        % Below, we find s(z^i_1,...,z^i_{k-1}, z^j_1,...,z^j_{k-1}, \theta )
        % with the product:
        % \tilde l(z^i_1,...,z^i_{k-1}, z^j_1,...,z^j_{k-1}|\theta) x p( \theta )
        [ C_tlj, mu_tlj ] = multocondwprior(  C_tl, a_tl, B_tl, sig_theta^2, mu_theta );
        % This is the joint model implied with the likelihood stored in  C_tl, a_tl, B_tl
        
        % Use this as a prior for the current update and find
        % the joint involving the update term
        
        % i) reorder terms as \theta, z^i_{1:k-1} z^j_{1:k-1}
        [ C_tljre, mu_tljre ] = gordervar( C_tlj, [length(mu_tlj),[1:length(mu_tlj)-1]], mu_tlj );
        % ii) multiply q( z^i_k, z^j_k |\theta, z^i_{1:k-1}, z^j_{1:k-1} , )
        % with q( \theta, z^i_{1:k-1} z^j_{1:k-1} ) found above and find
        % the extended model tilde l joint extended
        [ C_tlje, mu_tlje ] = multocondwprior(  C_dual, a_dual, B_dual, C_tljre, mu_tljre );
        % iii) order from z^i_k, z^j_k, \theta, z^i_{1:k-1}, z^j_{1:k-1}
        % to \theta z^i_{1:k-1} z^i_k z^j_{1:k-1}, z^j_{k}
        
        [ C_tlje, mu_tlje ] = gordervar( C_tlje, [3,zi_hist,1,zj_hist,2] , mu_tlje );
        % Now, given this joint, find the conditional given theta as the
        % updated likelihood
        [ C_tl, mu_dummy, a_tl, B_tl ] = gausscond( C_tlje, [1], mu_tlje  );
        
        % Now, using the joint, find the conditional given the measurements
        % which is the posterior
        [ C_posts, mu_dummy, a_posts, B_posts ] = gausscond( C_tlje, [2:length(mu_tlje)], mu_tlje  );
        
         % Find s(z^i_{1:k}, z^j{1:k})
        [ C_szs, mu_szs] = gaussmarg( C_tlje, [2:length(mu_sj)] ,mu_tlje );
   
    end
    
    d_lhood_dual(k) = gkldcond(  sig_theta^2, mu_theta,   C_l, a_l, B_l,  C_tl, a_tl, B_tl );
    
    if k>=2
        d_post_dual(k) = gkldcond( C_pzs, mu_pzs,  C_postp, a_postp, B_postp, C_posts, a_posts, B_posts);
        d_zs_dual(k) = gkld(  C_pzs, C_szs, mu_pzs, mu_szs );
    end
end


figure
hold on
grid on
plot(d_dual)
plot( d_dual2 ,'r')
xlabel('k')
ylabel('D(p||s)')
legend('explicit cond. KLD','differences of kld of joints')

figure
subplot(211)
hold on
grid on
plot(d_dual)
plot(d_pz2sz,'g')
plot(d_pz2sz2,'r')
xlabel('k')
ylabel('KLD (nats)')
legend('D(p(z|z,theta)||s(z|z,theta))','D(p(z|z)||s(z|z))','D(p(z|z)||s(z|z))')

%subplot(212)
figure
hold on
grid on
plot(cumsum(d_pz2sz ))
plot(d_zs_dual,'r')
legend('cumsum(D(p(z|z)||s(z|z)))','D(p(z)||s(z))')
title('Need to find out why these two lines are different')

%% Check the figure above to make sure that the relation between
% the posterior and the KLDs in
% 'D(p(z|z,theta)||s(z|z,theta))','D(p(z|z)||s(z|z))' are established
% correctly

figure
hold on
grid on
plot( cumsum(d_dual), 'k' )
plot( d_lhood_dual, 'r' )
xlabel('k')
ylabel('D(l || l_q)')
legend('sum of cond. KLDs','explicit cond. KLD')



figure
subplot(211)
hold on
grid on
plot( d_lhood_dual, 'k' )
plot(d_zs_dual)
legend('D(l(Z|\theta)|| l_s(z|\theta))','D(p(z)||s(z))')

subplot(212)
hold on
grid on
plot( d_lhood_dual - d_zs_dual  )
plot(d_post_dual,'r')
legend('D(l(Z|\theta)|| l_s(z|\theta)) - D(p(z)||s(z))','D(p(\theta|Z)||q(\theta|Z))')

figure
subplot(211)
plot( cumsum(d_dual) )
legend('D(l(Z|\theta)|| l_s(z|\theta))')
subplot(212)
plot( d_post_dual )
legend('D(p(\theta|Z)||q(\theta|Z))' )

