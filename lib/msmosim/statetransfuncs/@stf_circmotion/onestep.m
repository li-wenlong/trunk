function varargout = onestep(this, varargin )

if nargin >= 2
    dt = varargin{1}(1);
    if ~isnumeric( dt )
       error('Input should be a scalar'); 
    end
else
    dt = this.deltat;
end

this.i1 =  this.i1.init('deltat', dt);
this.i2 =  this.i2.init('deltat', dt);
this.i3 =  this.i3.init('deltat', dt );
this.i4 =  this.i4.init('deltat', dt );

xe = this.location; % [x y z]
w  = this.angularvelocity; % [p q r]
M  = this.angularmoment; % [Mx My Mz]
eang = this.orientation; % [psi, theta, phi ]
I = this.Inertia; % I
Idot = this.Idot; % Idot

a = this.acceleration; % [ax ay az]
v = this.velocity; % [u v w]

ve = this.velearth;
ae = this.accelearth;

%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the acceleration a for the circular motion
speed = norm(v);
% Find the direction of the force
fd = this.centre - xe;
R = norm(fd);
% Find the rotation axis
r = cross( fd/R, v/speed  );

deltatheta = speed*this.deltat/R;

if this.clockwise == 0
    deltatheta = -deltatheta;
end

xtp1 = rotr( r, -deltatheta , -fd ) + this.centre;
vtp1 = rotr( r, -deltatheta , v );

ae = speed^2/R*(fd/R);

aed = (vtp1 - ve)/dt;
ved = (xtp1 - xe)/dt;

% 1 - Update the location
xe = xe + ved*dt;

% 2 - Update the Euler angles
int_ = this.i2;
eang = int_.getoutp( this.i2inp );
this.i2 = int_;
%eang = this.i2.getoutp( this.i2inp );

% Take the DCM Matrix
R_be = dcm( eang );

% 3 Update ve and vb
ve = ve + aed*dt;
this.setvelearth(ve);
% this.setvelearth( ved );


this.orientation =  eang ;
this.location = xe;

% 4 - update w = [p q r]
int_ = this.i4;
w = int_.getoutp( this.i4inp );
this.i4 = int_;
%w = this.i4.getoutp( this.i4inp );
this.angularvelocity = w;

% Calculate pdot qdot rdot
% i.e., Update euler rates
edot = [ 0      sin( eang( 3 ) )/cos( eang( 2 ) )       cos( eang(3) )/cos( eang( 2 ) );...
         0      cos(eang( 3 ))                          -sin(eang( 3 ));...
         1      sin( eang( 3 ) )*tan(eang(2))           cos( eang( 3 ) )*tan( eang(2) ) ]*w;


a = R_be*ae;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
this.setacceleration( a );    
     
this.i2inp = edot; % psidot thetadot phidot
this.i4inp = I^(-1)*( M - Idot*w - cross(w, I*w ) ); % wdot


 
% Proceed the time
this = this.settime( this.time + dt);

% Update the step
this.catstate;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end

