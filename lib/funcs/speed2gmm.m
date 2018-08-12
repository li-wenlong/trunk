function g = speed2gmm( s )

s = s(:);

zind = find(s<eps);
s = s( setdiff([1:length(s)],zind)  );

if isempty(s)
    g = gmm;
    g = g([]);
    return;
end

%vecs = [ [1 0]',[1/sqrt(2) 1/sqrt(2)]',[0 1]',[-1/sqrt(2) 1/sqrt(2)]',...
%    [-1 0]',[-1/sqrt(2) -1/sqrt(2)]',[0 -1]',[-1/sqrt(2) 1/sqrt(2)]'];

vect = [1 0]';
angs = [0, pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4];

[nc] = length(angs);
comps = [];
for i=1:length(s)
    for j=1:nc
        R = rotmat2d( angs(j) );
        comps = [comps, gk( R*[(s(i)/12)^2 , 0;0 (s(i)*tan(pi/4/2)/1.5)^2]*R', R*vect*s(i) )] ;
    end
end

g=gmm( ones(1,length(comps)), comps);
    

