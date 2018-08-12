ws = [1,ones(1,999)*0];
ws = ws/sum(ws);
N_eff = 1/sum(ws.^2)


Neff_des = 3;
N = length(ws);
as = roots([(N-N^2/Neff_des) (2-2*N/Neff_des) (1-1/Neff_des)]);
aind = find(as>0);
a = as( aind );

ws = ws+a;
ws = ws/sum(ws);
N_eff = 1/sum(ws.^2)

edgelength = 3000;
numgridpoints = 100;
gridcellwidth = (edgelength)/(sqrt(numgridpoints)-1); 
isDeltaShift = 0;
if isDeltaShift
    deltashift = gridcellwidth/2;
else
    deltashift = 0;
end
% Find the grid over the square centered at the origin with edge size edgelength;
[initgrid_x,initgrid_y] = meshgrid([-(edgelength/2):gridcellwidth:(edgelength/2)]+deltashift/2,...
    [-(edgelength/2):gridcellwidth:(edgelength/2)]);
initgrid_pts_loc = [initgrid_x(:),initgrid_y(:)]';




numgridpoints = size( initgrid_pts_loc, 2);
w = zeros(1,numgridpoints);
w(15) = 1;
p1 = particles('states', initgrid_pts_loc, 'weights', w ,'labels', 1);
p1.draw
p1.findkdebws('nonsparse');
p1.resample; % make it equally weighted kernel
p1.draw('axis',gca,'options','''Color'',[0 1 0],''linestyle'',''none'',''Marker'',''.''')
p1.regwkde; % Generate samples from the equally weighted kernel sum
p1.draw('axis',gca,'options','''Color'',[1 0 0],''linestyle'',''none'',''Marker'',''.''')

w = zeros(1,numgridpoints);
w( fix( sqrt( numgridpoints )) + 1) = 1;
p1 = particles('states', initgrid_pts_loc, 'weights', w ,'labels', 1);
p1.draw
p1.findkdebws('nonsparse');
p1.resample; % make it equally weighted kernel
p1.draw('axis',gca,'options','''Color'',[0 1 0],''linestyle'',''none'',''Marker'',''.''')
p1.regwkde; % Generate samples from the equally weighted kernel sum
p1.draw('axis',gca,'options','''Color'',[1 0 0],''linestyle'',''none'',''Marker'',''.''')


minval = min( abs( initgrid_pts_loc(1,:) ) );
[minval mininds] = find( abs(initgrid_pts_loc(1,:)) == minval );
[minval mininds2 ] = min( abs(initgrid_pts_loc(2,mininds)) );
minind = mininds( mininds2(1) );
w = zeros(1,numgridpoints);
w(minind(1) ) = 1;
p1 = particles('states', initgrid_pts_loc, 'weights', w ,'labels', 1);
p1.draw
p1.findkdebws('nonsparse');
p1.resample; % make it equally weighted kernel
p1.draw('axis',gca,'options','''Color'',[0 1 0],''linestyle'',''none'',''Marker'',''.''')
p1.regwkde; % Generate samples from the equally weighted kernel sum
p1.draw('axis',gca,'options','''Color'',[1 0 0],''linestyle'',''none'',''Marker'',''.''')

