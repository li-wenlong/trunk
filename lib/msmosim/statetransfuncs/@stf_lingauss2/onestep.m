function varargout = onestep(this, varargin )

if nargin >= 2
    dt = varargin{1}(1);
    if ~isnumeric( dt )
       error('Input should be a scalar'); 
    end
    this.dT = dt;
else
    dt = this.dT;   
end
    

this = updatemodel(this, dt, this.psd );


this.state = this.F*this.state;
% Generate process noise
nu = this.srQ*randn(size(this.state));

this.state = this.state + nu;

% Add a field to the cfg class for the rng state
% set this field on if the cfg 
if norm(imag(this.state))>eps
    error('State transition led a complex vector. Possibly non-square rooted covariance matrix!');
end

this = this.substate(this.state);

% Update the step
this.catstate;
 
% Proceed the time
this = this.settime( this.time + dt);



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

