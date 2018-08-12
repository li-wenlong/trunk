% This script is to test the NBP implementation

defaultGMRF;
defaultLikelihoods;

V = [1,2,3,4];
E = [[1 3];[2 3];[3 4];[3 1];[3 2];[4 3]];

myugcfg = ugcfg;
myugcfg.V = V;
myugcfg.E = E;
myugcfg.mschedule = {[[1 3];[2 3];[4 3]],[[3 1];[3 2];[3 4]]};
mygraph = ug( myugcfg );

numsaples = 1000;
numbins = 20;

p_x = gk( C_x, mu_x_1234 );

x_samples = p_x.gensamples(numsaples);

p_n_1 = gk( sigmasq_n1, mu_n1 );
p_n_2 = gk( sigmasq_n2, mu_n2 );
p_n_3 = gk( sigmasq_n3, mu_n3 );
p_n_4 = gk( sigmasq_n4, mu_n4 );

p_n(1) = p_n_1;
p_n(2) = p_n_2;
p_n(3) = p_n_3;
p_n(4) = p_n_4;


n1_samples = p_n_1.gensamples(numsaples);
n2_samples = p_n_2.gensamples(numsaples);
n3_samples = p_n_3.gensamples(numsaples);
n4_samples = p_n_4.gensamples(numsaples);

y_samples = x_samples;

y_samples(1,:) =  n1_samples + x_samples(1,:);
y_samples(2,:) =  n2_samples + x_samples(2,:);
y_samples(3,:) =  n3_samples + x_samples(3,:);
y_samples(4,:) =  n4_samples + x_samples(4,:);

% Now, we will have samples generated from the posterior marginals using
% NBP
p1 = particles( 'states', x_samples(1,:) );
p1.findkdebws;
p2 = particles( 'states', x_samples(2,:) );
p2.findkdebws;
p3 = particles( 'states', x_samples(3,:) );
p3.findkdebws;
p4 = particles( 'states', x_samples(4,:) );
p4.findkdebws;

% Assign these particles as the initial state to the nodes
mygraph.nodes(1).state = p1;
mygraph.nodes(2).state = p2;
mygraph.nodes(3).state = p3;
mygraph.nodes(4).state = p4;

%%


%% Plot the samples generated from the marginal distributions and the measurement
% processes.
figure
subplot(411)
hold on
grid on
[pts, bins ]=hist( x_samples(1,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'b','Marker','o' )
[pts, bins ]=hist( y_samples(1,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'r','Marker','s' )
axis([-6, 6, 0, 0.5])

subplot(412)
hold on
grid on
[pts, bins ]=hist( x_samples(2,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'b','Marker','o' )
[pts, bins ]=hist( y_samples(2,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'r','Marker','s' )
axis([-6, 6, 0, 0.5])

subplot(413)
hold on
grid on
[pts, bins ]=hist( x_samples(3,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'b','Marker','o' )
[pts, bins ]=hist( y_samples(3,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'r','Marker','s' )
axis([-6, 6, 0, 0.5])
 
subplot(414)
hold on
grid on
[pts, bins ]=hist( x_samples(4,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'b','Marker','o' )
[pts, bins ]=hist( y_samples(4,:),numbins );
pts = pts/sum(pts)/( bins(2) - bins(1) );
plot( bins, pts, 'r','Marker','s' )
axis([-6, 6, 0, 0.5])

%%

fhandle = figure;


for stepcnt = 1:size( y_samples, 2 )
    
    % Get the measurements and compute the messages from the observed nodes
    
    for i=1:length( mygraph.V )  
        % Calculate the message from the observed node
        w = p_n(i).evaluate( y_samples(i, stepcnt) - mygraph.nodes(i).state.states );
        
        pp = mygraph.nodes(i).state;
        
        pp = pp.subweights( w );
        pp = pp.resample;
        pp = pp.findkdebws;
        
        mymessage = message;
        mymessage.from = 1000 + mygraph.V(i);
        mymessage.to = mygraph.V(i);
        
        
        mygraph.nodes(i) = pp;
    end
    
%    mygraph.bp;
    
    
    % Get the results and plot
    p1 = mygraph.nodes(1).state;
    p2 = mygraph.nodes(2).state;
    p3 = mygraph.nodes(3).state;
    p4 = mygraph.nodes(4).state;
    
    
   % mygraph.proceed;
    
    figure(  fhandle )
    clf;
    subplot(411)
    hold on
    grid on
    [pts, bins ]=hist( x_samples(1,:),numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'b','Marker','o' )
    [pts, bins ]=hist( p1.states,numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'r','Marker','s' )
    axis([-6, 6, 0, 0.5])
    
    subplot(412)
    hold on
    grid on
    [pts, bins ]=hist( x_samples(2,:),numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'b','Marker','o' )
    [pts, bins ]=hist( p2.states, numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'r','Marker','s' )
    axis([-6, 6, 0, 0.5])
    
    subplot(413)
    hold on
    grid on
    [pts, bins ]=hist( x_samples(3,:),numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'b','Marker','o' )
    [pts, bins ]=hist( p3.states, numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'r','Marker','s' )
    axis([-6, 6, 0, 0.5])
    
    subplot(414)
    hold on
    grid on
    [pts, bins ]=hist( x_samples(4,:),numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'b','Marker','o' )
    [pts, bins ]=hist( p4.states,numbins );
    pts = pts/sum(pts)/( bins(2) - bins(1) );
    plot( bins, pts, 'r','Marker','s' )
    axis([-6, 6, 0, 0.5])
    
    drawnow;
    pause(0);
    
    
end
    

