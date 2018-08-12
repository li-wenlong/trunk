% This script is for manipulations of the following AR-1 Markov
% Chain for k=1,...,t and estimation of an unknown parameters theta:
% x_k = a x_km1 + v_k
% with v_k ~ N(.;0,sig_v), x1 ~ N(.;0,sig_x1)
% zi_k = x_k + ni_k
% with ni_k ~ N(.;0,sig_ni) 



sig_ni = 1;
mu_ni = 0;

sig_x1 = sqrt( 1*(1/(1-0.5^2) ) );
mu_x1 = 0;

a = 0.5;

sig_v = 1;
mu_v = 0;

t = 100; % This is the length of the time window

% construct mu_x
mu_x = [mu_x1];
for i=2:t
    mu_x = [ mu_x; mu_x(end)*a + mu_v ];
end

mu_xni    = [ mu_x; mu_ni*ones(t,1) ];

x_ind = [1:t];
zi_ind = x_ind(end) + [1:t];

% Now, construct C_x in accordance with the AR1 Markov chain 
% x_1 ~ N(.;0,sig_x1 )
% x_k = a x_km1 + v_k for k=2,...,t
% with v_k ~ N(.;0,sig_v)
A = fliplr( hankel([ zeros(1,t-2) 1 -a] ) );
A = A(1:end-1,:);

C_x_inv =  transpose(A)*( eye(t-1)*(1/sig_v^2) )*A ;
C_x_inv(1) = C_x_inv(1) + 1/sig_x1^2 ;

% Now, construct C_xbarninj
C_all_inv = blkdiag( C_x_inv, eye(t)*(1/sig_ni^2) );

T = blkdiag( eye(t), eye(t) );

Hi = eye(t);

T(t+1:t+1+t-1,1:t) = -Hi;

% Now, find C_joint = C_xbarzizj
C_joint_inv = transpose(T)*C_all_inv*T;
mu_joint = inv(T)*mu_xni;

dim = size( C_joint_inv , 2 );

nu_xni = C_joint_inv*mu_joint;


R = chol(C_joint_inv);
Rinv = R^(-1);

C_joint = Rinv*Rinv';

%p_joint = gk( C_joint, mu_xni ); 


% This is p( x | zi )
[C_xGzi, mu_xGzi, a_xGzi, B_xGzi ] = gausscond( C_joint, [zi_ind], mu_joint  );

% This is p( zi | x )
[C_ziGx , mu_ziGx, a_ziGx, B_ziGx ] = gausscond( C_joint, [1:t] , mu_joint );

%% Find the entropies of time prediction and posterior distributions
for k=1:t
    % Find the time posterior
    % 1) Find p( x_k , z^i_{1:k} )
    var_ind = [x_ind(k), zi_ind(1:k)];
    [ C_xzi, mu_xzi ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k} )
    [ C_xGzi, mu_xGzi, a_xGzi, B_xGzi ] = gausscond( C_xzi, [2:2+k-1], mu_xzi  );
    
    
    % Find the time prediction
    % 1) Find p(  x_k , z^i_{1:k-1}  ) 
    var_ind = [x_ind(k), zi_ind(1:k-1)];
    [ C_xzihist, mu_xzihist ] = gaussmarg( C_joint, var_ind, mu_joint );
    
    % 2) Find p( x_k | z^i_{1:k-1} )
    if k==1
        C_xGzihist = C_xzihist;
        mu_xGzihist = mu_xzihist;
    else
        [ C_xGzihist, mu_xGzihist, a_xGzihist, B_xGzihist ] = gausscond( C_xzihist, [2:2+k-2], mu_xzihist  );
    end
    
    
    Hpred = gentropy( C_xGzihist ); % H(x_k | z^j_{1:k-1})
    Hpost = gentropy( C_xGzi ); % H(x_k | z^j_{1:k})
 
    H_pred(k) =  Hpred;
    H_post(k) = Hpost;
    
    % Find the marginal distribution of the state p(x_k)    
    if k == 2
       [ C_xkm1, mu_xkm1 ] = gaussmarg( C_joint, x_ind(k-1), mu_joint );
    end
    if k>=2
       [ C_xk, mu_xk ] = gaussmarg( C_joint, x_ind(k), mu_joint );
        
       % Find the divergence from the previous marginal
       divxk(k) = gkld(C_xk, C_xkm1, mu_xk, mu_xkm1 );
       
       % Save the current ones
       C_xkm1 = C_xk; mu_xkm1 = mu_xk;
    end
    
    
end

%% Plot the entropies
figure
fhandle = gcf;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize', 14 )
grid on
hold on
plot(H_pred)
plot(H_post,'r')
legend('pred','post')
xlabel('t','FontSize',14)
ylabel('H (nats)','FontSize',14)
drawnow;

figure
fhandle = gcf;
ahandle = gca;
set( fhandle, 'Color', [1 1 1]);
set( ahandle, 'FontSize', 14 )
grid on
hold on
plot(divxk)
xlabel('k','FontSize',14)
ylabel('D(p(x_k)||p(x_{k-1})) (nats)','FontSize',14)
drawnow;


%% Generate samples from the joint model
jm = cpdf( gk( C_joint, mu_joint  ) );
% sample array sa
sa = jm.gensamples( 10000 );
xsamp = sa( x_ind ,:)';
zsamp = sa( zi_ind ,:)';

%% Now, plot the generated samples

efhandle = figure;
set( efhandle, 'color', [1 1 1] );
set( efhandle, 'doublebuffer', 'on' );
set( efhandle, 'Color', [1 1 1] );

efaxis = subplot(211);
efaxis2 = subplot(212);

subplot(211)
set( efaxis, 'XtickMode', 'auto' )
set( efaxis, 'FontSize', 14 )
grid(efaxis,'on')
hold(efaxis,'on')

x_tick = [1:1:t]';
boxplot( efaxis, xsamp ,  'boxstyle','outline','outliersize',  2, 'symbol', '>r','whisker',1.5,'medianstyle','line','labels',x_tick,'labelorientation','inline')
set( efaxis, 'XtickMode', 'auto' )
set( efaxis, 'XTick', [1,[5:5:t]] )
set( efaxis, 'YTick', [-15:5:15] )
set( efaxis, 'XTickLabel', [num2str( [1,[5:5:t]]')] )
set( efaxis, 'FontSize', 14 )

xlabel(efaxis,'t','FontSize',14)
ylabel(efaxis, 'x_t','FontSize',14)
drawnow;

% Plot the zs samples
subplot(212)
grid(efaxis2,'on')
hold(efaxis2,'on')
set( efaxis2, 'XtickMode', 'auto' )
set( efaxis2, 'FontSize', 14 )

x_tick = [1:1:t]';
boxplot( efaxis2, zsamp ,  'boxstyle','outline','outliersize',  2, 'symbol', '>r','whisker',1.5,'medianstyle','line','labels',x_tick,'labelorientation','inline')
set( efaxis2, 'XtickMode', 'auto' )
set( efaxis2, 'XTick', [1,[5:5:t]] )
set( efaxis2, 'YTick', [-15:5:15] )
%axis( efaxis2,   [0 t  -10 10])
set( efaxis2, 'XTickLabel', [num2str( [1,[5:5:t]]')] )
set( efaxis2, 'FontSize', 14 )

xlabel(efaxis2,'t','FontSize',14)
ylabel(efaxis2,'z_t','FontSize',14)
drawnow;




