
numparticles = 1000;


R1 = rotmat2d(-pi*45/180);
zetas = [0.25, 0.25, 0.25, 0.25];
%mus = [[-1;0], [0;1]*0.05, [0;-1]*0.05 ];
mus = [[-1;0], [0;1], [0;-1],[5;0] ];
sigmasqs = { R1*[0.05, 0;0 0.005]*R1', R1*[0.05, 0;0 0.005]*R1', ...
    R1*[0.05, 0;0 0.005]*R1',  R1*[0.05, 0;0 0.005]*R1' };
gks = gk;
for i=1:length(zetas)
gks(i) = gk( sigmasqs{i}, mus(:,i) );
end
s0 = gmm( zetas, gks );
[P0, labels] = s0.gensamples(numparticles);

p = particles( 'states', P0, 'labels', labels, 'weights', 1/numparticles );

p.updatekdebws('nonsparse');