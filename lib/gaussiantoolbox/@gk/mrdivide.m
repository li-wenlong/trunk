function c = mrdivide(a,b)
% a/b
if isa(a,'gk') && isa(b,'gk')
    if b.isScalar == 1 && a.isScalar == 0
        % a is active gk b is a scalar
        c = a/b.sval;
    elseif b.isScalar == 0 && a.isScalar == 1
        % a is a scalar and b is active gk
        c = a.sval/b;   
    else
        % a.isScalar == 1 && b.isScalar == 1
        b.C = -b.C;
        % R = chol(b.C);
        % Rinv = R^(-1);
        % % Construct the inverse covariance
        % b.S = Rinv*Rinv';
        b.S = inv(b.C);
        b.Z = 1/b.Z;
        c = a*b;
    end
elseif isa(a,'gk') && isnumeric(b)
    c = a;
    c.Z = c.Z/b;
elseif isa(b,'gk') && isnumeric(a)
    c = b;
    c.C = -c.C;
    % R = chol(b.C);
    % Rinv = R^(-1);
    % % Construct the inverse covariance
    % b.S = Rinv*Rinv';
    c.S = inv(c.C);
    c.Z = a/c.Z;
else
    % One of them is gk

end

