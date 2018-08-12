function c = findincells( a, b )

c = [];
if length(b)==1
    r = strcmpi(b,a(:) );
    c = find( r==1);
    if length(c)>1
        c = c(1);
    end
%     for j=1:length(a)
%         if strcmp( a{j}, b{1} )
%             c = [c; j ];
%         end
%     end
elseif length(a) == 1
    r = strcmpi(a,b(:) );
    c = find( r==1);
    if length(c)>1
        c = c(1);
    end
else
    error('One of the cell arrays should of length 1...');
end