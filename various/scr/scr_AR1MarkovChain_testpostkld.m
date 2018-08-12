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


% Construct the joint model for the quad term separable likelihood
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
    
    % For the quad-term update
    % Find p( z^i_k, z^j_k, z^i_{1:k-1},\theta)
    [ C_zszi, mu_zszi ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k), zj_ind(k), zi_ind(1:k-1) ], mu_joint );
    % Find p( z^i_k, z^j_k | z^i_{1:k-1},\theta)
    [ C_zsGzi, mu_zsGzi, a_zsGzi, B_zsGzi  ] = gausscond( C_zszi, [1,[4:4-1+k-1]] , mu_zszi );
   
    
    % Find p( z^i_k, z^j_k, z^j_{1:k-1},\theta)
    [ C_zszj, mu_zszj ] =  gaussmarg( C_joint, [theta_ind, zi_ind(k),zj_ind(k),zj_ind(1:k-1) ] , mu_joint );
    % Find  p( z^i_k, z^j_k| z^j_{1:k-1},\theta)
    [ C_zsGzj, mu_zsGzj, a_zsGzj, B_zsGzj  ] = gausscond( C_zszj, [1,[4:4-1+k-1]], mu_zszj );
    
    % Take the EMD for w=0.5
    [ C_quadup, a_quadup, B_quadup  ] = emdocond( C_zsGzi, a_zsGzi, B_zsGzi, C_zsGzj, a_zsGzj, B_zsGzj , 0.5, [1] );
    % q(z^i_k, z^j_k| \theta, z^i_{1:k-1}, z^j_{1:k-1})
    
    % Find the KLD of the conditionals, i.e.,
    % D( p( z^i_k, z^j_k | theta, z^i_{1:k-1}, z^j_{1:k-1}) || q(z^i_k, z^j_k| \theta, z^i_{1:k-1}, z^j_{1:k-1})  )
    
    % Find the prior for theta, zi_hist, zj_hist
    % i.e., p( z^i_{1:k-1}, z^j_{1:k-1} , \theta)
    prior_ind = [theta_ind, zi_ind(1:k-1), zj_ind(1:k-1)];
    [ C_prior, mu_prior] = gaussmarg( C_joint, prior_ind, mu_joint );
   
    
    d_quad(k) = gkldcond( C_prior, mu_prior,  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_quadup, a_quadup, B_quadup);
    
    
    
    %% Compute KLD using
    % D(p(x|y)|| q(x|y) ) =  D( p(x,y)|| q(x,y) ) - D( p(y) || q(y) ) and
    % the last term is zero since p(y)= q(y) in our case.
    
    % Multiply q( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} ) and p( \theta, z^i_{1:k-1}, z^j_{1:k-1} )
    % get q( z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1} )
   [ C_qj, mu_qj ] = multocondwprior(  C_quadup, a_quadup, B_quadup, C_prior, mu_prior );
   [ C_qj, mu_qj ] = gordervar( C_qj, [3 1 2 [4:length(mu_qj)]] , mu_qj );
    
    [ C_pj2, mu_pj2 ] = multocondwprior(  C_zsGzizj, a_zsGzizj, B_zsGzizj, C_prior, mu_prior );
    [ C_pj3, mu_pj3 ] = gordervar( C_pj2, [3 1 2 [4:length(mu_qj)]] , mu_pj2 );
    
    % Note that D( p( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} ) || q( z^i_k, z^j_k | \theta, z^i_{1:k-1}, z^j_{1:k-1} )  ) =
    % D( p(z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1})|| q(z^i_k, z^j_k , \theta, z^i_{1:k-1}, z^j_{1:k-1}) ) - D( prior() || prior() ) 
    % as we use the same prior() in the joints p() and q(): 
    d_quad2(k) = gkld( C_pj3, C_qj, mu_pj3, mu_qj  );
    
    %% AS a by-product on the way,  
    % find the KLD D( p( z^i_k, z^j_k | z^i_{1:k-1}, z^j_{1:k-1})  || q(z^i_k, z^j_k| z^i_{1:k-1}, z^j_{1:k-1})   )
    
    % Marginalize \theta out from the joint
    [C_qzj, mu_qzj] = gaussmarg(C_qj, [2:length(mu_qj)] , mu_qj );
    % Find the conditional 
    [C_qzjcond, mu_qzjcond, a_qzjcond, B_qzjcond ] = gausscond(C_qzj, [3:length(mu_qzj)] ,mu_qzj );
    
    % Similarly marginalise out \theta
    [C_pzj, mu_pzj] = gaussmarg(C_pj3, [2:length(mu_pj3)] , mu_pj3 );
    [C_pzjcond, mu_pzjcond, a_pzjcond, B_pzjcond ] = gausscond(C_pzj, [3:length(mu_pzj)] ,mu_pzj );
    
    [C_pr, mu_pr ] = gaussmarg( C_prior, [2:length(mu_prior)], mu_prior );
    
    d_pz2qz(k) =  gkldcond( C_pr, mu_pr,  C_pzjcond, a_pzjcond, B_pzjcond, C_qzjcond, a_qzjcond, B_qzjcond); 
    
    % This one produces the same result with the line above
    d_pz2qz2(k) = gkld( C_pzj, C_qzj, mu_pzj, mu_qzj );%
    
    
    
    
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
        C_tl =  C_quadup; a_tl = a_quadup; B_tl = B_quadup;
    else
        % Below, we find q(z^i_1,...,z^i_{k-1}, z^j_1,...,z^j_{k-1}, \theta )
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
        [ C_tlje, mu_tlje ] = multocondwprior(  C_quadup, a_quadup, B_quadup, C_tljre, mu_tljre );
        % iii) order from z^i_k, z^j_k, \theta, z^i_{1:k-1}, z^j_{1:k-1}
        % to \theta z^i_{1:k-1} z^i_k z^j_{1:k-1}, z^j_{k}
        
        [ C_tlje, mu_tlje ] = gordervar( C_tlje, [3,zi_hist,1,zj_hist,2] , mu_tlje );
        % Now, given this joint, find the conditional given theta as the
        % updated likelihood
        [ C_tl, mu_dummy, a_tl, B_tl ] = gausscond( C_tlje, [1], mu_tlje  );
        
        % Now, using the joint, find the conditional given the measurements
        % which is the posterior
        [ C_postq, mu_dummy, a_postq, B_postq ] = gausscond( C_tlje, [2:length(mu_tlje)], mu_tlje  );
        
         % Find q(z^i_{1:k}, z^j{1:k})
        [ C_qzs, mu_qzs] = gaussmarg( C_tlje, [2:length(mu_qj)] ,mu_tlje );
   
    end
    
    d_lhood(k) = gkldcond(  sig_theta^2, mu_theta,   C_l, a_l, B_l,  C_tl, a_tl, B_tl );
    
    if k>=2
        d_post(k) = gkldcond( C_pzs, mu_pzs,  C_postp, a_postp, B_postp, C_postq, a_postq, B_postq);
        d_zs(k) = gkld(  C_pzs, C_qzs, mu_pzs, mu_qzs );
    end
end


figure
hold on
grid on
plot(d_quad)
plot( d_quad2 ,'r')
xlabel('k')
ylabel('D(p||q)')
legend('explicit cond. KLD','differences of kld of joints')

figure
subplot(211)
hold on
grid on
plot(d_quad)
plot(d_pz2qz,'g')
plot(d_pz2qz2,'r')
xlabel('k')
ylabel('KLD (nats)')
legend('D(p(z|z,theta)||q(z|z,theta))','D(p(z|z)||q(z|z))','D(p(z|z)||q(z|z))')

%subplot(212)
figure
hold on
grid on
plot(cumsum(d_pz2qz ))
plot(d_zs,'r')
legend('cumsum(D(p(z|z)||q(z|z)))','D(p(z)||q(z))')
title('Need to find out why these two lines are different')

%% Check the figure above to make sure that the relation between
% the posterior and the KLDs in
% 'D(p(z|z,theta)||q(z|z,theta))','D(p(z|z)||q(z|z))' are established
% correctly

figure
hold on
grid on
plot( cumsum(d_quad), 'k' )
plot( d_lhood, 'r' )
xlabel('k')
ylabel('D(l || l_q)')
legend('sum of cond. KLDs','explicit cond. KLD')



figure
subplot(211)
hold on
grid on
plot( d_lhood, 'k' )
plot(d_zs)
legend('D(l(Z|\theta)|| l_q(Z|\theta))','D(p(z)||q(z))')

subplot(212)
hold on
grid on
plot( d_lhood - d_zs  )
plot(d_post,'r')
legend('D(l(Z|\theta)|| l_q(Z|\theta)) - D(p(z)||q(z))','D(p(\theta|Z)||q(\theta|Z))')

figure
subplot(211)
plot( cumsum(d_quad) )
legend('D(l(Z|\theta)|| l_q(Z|\theta))')
subplot(212)
plot( d_post )
legend('D(p(\theta|Z)||q(\theta|Z))' )

