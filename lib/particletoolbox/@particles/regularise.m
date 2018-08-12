function varargout = regularise( these )



[nx Np] = size( these.states );
xdim = nx;

% this is nx=4 only
A = (4/(nx+2))^(1/(nx+4));
h_fact =  A * Np^(-1/(nx+4));
C = wcov( these.states, these.weights );

if rcond(C)>eps
    %Am = sqrtm(C);
    try
        Am = chol(C)';
    catch
        disp(sprintf('Could not decompose C by chol() !'));
        Am = 0.00001*eye(xdim);
    end
else
    %disp('Problem with sqrtm in C matrix');
    Am = 0.00001*eye(xdim);
end
if ~isreal(Am)
    Am = 0.00001*eye(xdim);
end
gauss_mat = randn(nx,Np);

these.states = these.states + 0.1*h_fact * Am *gauss_mat;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),these);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = these;
end
