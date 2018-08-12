function  [m, varargout] = mindistobjects(Xt)

m = zeros(length(Xt),1);
t = zeros(length(Xt),2);
for i=1:length(Xt)
    D = distance( Xt{i},Xt{i});
    D = D + diag( ones( 1, size(D,1) )*Inf );
    [ colmins, rind ] = min(D);
    [minval, cind] = min( colmins );
    
    m(i) = minval;
    t(i,:) = [rind(cind),cind];
end

if nargout>=2
    varargout{1 } = t;
end