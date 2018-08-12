function c = mtimes(a,b)
if isa(a,'gk')
    a = mergegks(a);
end
if isa(b,'gk')
b = mergegks(b);
end
if isa(a, 'gk') && isnumeric(b)
    numa = prod( size(a) );
    numb = prod(size(b));
    if numa ~=numb
        if numa~=1 && numb~=1
            error('Argument sizes mismatch');
        end
    end
    if numa == 1
        c( 1:prod( size(b) ) ) = a;
        
    else
        c = a;
        b = b*ones(size(a));
    end
    bCol = b(:);
    for i = 1:length( bCol )
        if c(i).isScalar == 1
            c(i).sval = real( exp( log(c(i).sval) + log( bCol(i) ) ) );
        else
            c(i).Z = real( exp( log( c(i).Z) + log( bCol(i) ) ) );
        end
    end
    c = reshape(c, size(b));
    return;
elseif isa(a, 'gk') && isa(b, 'gk')
    
    if length(a) == 1 && length(b) == 1
        if a.isScalar == 1 && b.isScalar == 1
            c = a*b.sval;
        elseif a.isScalar == 1 && b.isScalar == 0
            c = b*a.sval;
        elseif a.isScalar == 0 && b.isScalar == 1
            c = a*b.sval;
        else
            c = a;
            c.S = (a.S + b.S);
                 R = chol(c.S);
                 Rinv = R^(-1);
            %     % Construct the inverse
                 c.C = Rinv*Rinv';
            % c.C = inv(c.S);
            c.m = c.C*a.S*a.m + c.C*b.S*b.m;

            c.Z = real( exp( log(a.Z) + log(b.Z) + ( -0.5*( a.m'*a.S*a.m + b.m'*b.S*b.m - c.m'*c.S*c.m ) ) ) );
        end
        
    else
        % perform as if multiplication of two summations 
        % (x_1 + ... + x_N)(y_1 + ... + y_M)
        c = gk;
        for i=1:length(a(:))
            for j=1:length(b(:))
               ind = (i-1)*length(b(:)) + j;
               c( ind ) = a(i)*b(j);
            end
        end
        c = mergegks(c);
    end
   
elseif isa(b, 'gk') && isnumeric(a)
    c = b*a;
    return; 
end