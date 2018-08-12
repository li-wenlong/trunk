function c = mtimes(a,b)

if isa(a, 'gmm') && isnumeric(b)
    error('This part is not implemented yet!!!')
    return;
elseif isa(a, 'gmm') && isa(b, 'gmm')
    
    if length(a) == 1 && length(b) == 1
       c = gmm2gk(a)*gmm2gk(b);      
    else
       error('In an expression a*b, both a and b should be single gmm objects.');
    end
   
elseif isa(b, 'gmm') && isnumeric(a)
    c = b*a;
    return; 
end