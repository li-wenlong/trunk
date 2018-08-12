function [gmmeq, varargout ]= gk2gmm( g )


zs = getzs(g);
if ~isempty( find(zs<0))
    warning('Negative component in the gk array!!!');
end

sc = sum( zs ); % sc = ws.*ss where ss are the scale factors for components to integrate to 1
ss = getzs( cpdf( g ) );
ws = zs./ss;
gmmeq = gmm(ws, g );

if nargout>=2
    varargout{1} = sum(ws);
end
