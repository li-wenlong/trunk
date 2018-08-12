function c = times(a, b)

if abs( sum( size(a)-size(b)))~= 0
    error('In an expression a.*b, a and b should be of the same size.');
end
if isa( a, 'gk' )
    c = a;
elseif isa( b, 'gk')
    c = b;
end

for i=1:length(a(:))
    c(i) = a(i)*b(i);
end
    


% if isa(a, 'gk') && isnumeric(b)
%     c = a;
%     bCol = b(:);
%     for i = 1:length( bCol )
%         c(i) = c(i)*bCol(i);
%     end
%     c = reshape(c, size(b));
%     return;
% elseif isa(a, 'gk') && isa(b, 'gk')
%     c = gk;
%     for i=1:length(a(:))
%        c(i) = a(i)*b(i); 
%     end
%     c = reshape(c, size(a));
%     return;
% elseif isa(b, 'gk') && isnumeric(a)
%     c = b;
%     aCol = a(:);
%     for i = 1:length( aCol )
%         c(i) = c(i)*aCol(i);
%     end
%     c = reshape(c, size(a));
%     return; 
% end