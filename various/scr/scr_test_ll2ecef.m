
latarr = [-pi:pi/100:pi];
longarr = [-pi:pi/100:pi];

[latmesh, longmesh] = meshgrid(latarr, longarr );
[X,Y,Z] = lla2ecef( latmesh, longmesh, zeros(size(longmesh)) );



figure
hold on
grid on
surf(X,Y,Z)
lighting phong
shading('flat')
axis equal
