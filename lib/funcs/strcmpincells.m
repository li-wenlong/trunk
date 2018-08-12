function c = strcmpincells( a, b )
% STRCMPINCELLS uses strcmp in cell array a for the string b
%
% b = 'findthisstring'; 
% a = {'notthisstring','northisone','findthisstring'};
% c = strcmpincells(a, b) returns the location of b in a
%
%

% 21.10.2010 Murat Uney 


if isa(a, 'cell')
    a = a(:);
    if isa(b,'char')
        c = [];
        for j=1:length(a)
            if strcmp( a{j}, b )
                c = [c; j ];
            end
        end
    end 
else
   error('The first ') 
end
