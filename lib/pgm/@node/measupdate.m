function varargout = measupdate( this, y_vect)
% function varargout = @node.measupdate( y)
% is the measurement update method for a Gaussian UG node.
% The prior in the @node.initstate field is updated with y and the (myopic)
% posterior is saved in @node.state

% First, form the inverse covariance of the local joint distribution p(x,y)
% The inverse joint covariance matrix is given as below;
Lambda_x = this.initstate.S;
mu_x = this.initstate.m;
sigmasq_n_j = this.noisedist.C;

C_xy_inv = [ Lambda_x + diag( ones( size(Lambda_x,1),1 )*1/sigmasq_n_j ), -diag( ones( size(Lambda_x,1),1 )*1/sigmasq_n_j );...
    -diag( ones( size(Lambda_x,1),1 )*1/sigmasq_n_j ), diag( ones( size(Lambda_x,1),1 )*1/sigmasq_n_j )];

C_xy = C_xy_inv^(-1);

[C_xGy, mu_xGy, a_xGy, B_xGy ] = gausscond( C_xy, [size(Lambda_x,1)+1:size(C_xy,1) ] , [mu_x;zeros(length(y_vect),1)], y_vect );

newstate = cpdf( gk(C_xGy, mu_xGy ) );


this.state = newstate; % Update the state with the observation
if nargout == 0
    if ~isempty( inputname(1) )
        assignin( 'caller',inputname(1), this );
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
    if nargout>=2
        varargout{2} = newstate;
    end
end