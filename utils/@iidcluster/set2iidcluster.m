function [cl] = set2iidcluster(cl,X)


numsamples = 1000;

cl = iidcluster;
cl.card = [zeros(1,size(X,2)),1, zeros(1, 31 -size(X,2) -1 ) ]';


for i=1:size(X,2)
    gks(i)  = gk( diag([10,10,1,1]), X(:,i) );
end
    
cl.s.gmm = gmm( ones(size(X,2),1)/size(X,2), gks );

[p1, c1] = gensamples( cl.s.gmm, numsamples*size(X,2) );
% Get unique labels per each different entry in labels

locparticles = particles( 'states', p1, 'labels', c1 ); % create equal weighted particles
% locparticles.allnb; % All particles are by default created new born
locparticles = locparticles.subblabels(  c1 );

locparticles.kdebws('nonsparse'); % Here, the BWs are found

cl.s.particles = locparticles;
cl.s.kdes = [];
cl.s.gmm = [];