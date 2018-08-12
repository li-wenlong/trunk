function l = gt(gks, val)


if isa( gks,'gk' )
    if isnumeric(val)
        if length(val)>1
            error('The comparison should be made with a scalar.')
        end
        l = zeros(size(gks));
        for i=1:length(gks(:))
            if gks(i).isScalar == 1
                error('Can not compare a Gaussian Kernal in scalar mode.');
            end
            l(i) = gks(i).Z > val;
        end  
    else
         error('The comparison should be made with a real number.');
    end
elseif isnumeric(gks)
    if isa(val, 'gk')
        % Switch the arguments as well as the operator
        l = lt(val, gks);        
    %else
        % This does not happen
        
    end
else
    error('Can not perform this comparison!');
end
    
