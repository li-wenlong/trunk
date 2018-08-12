function xy = getxy(this, varargin )

timestep = varargin{1};
is_scs = 0; % sensor coordinate system

if length( varargin) >=2
    is_scs = 1;
end

i = timestep;
% Get the sensor report
srep = this.srbuffer(i);

pstate = srep.pstate;
sstate = srep.sstate;

plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );
xy = zeros(2, length(srep.Z));
for j = 1:length(srep.Z)
    % Get an observation
    z = srep.Z(j);
    tlocS = [ cos(z.bearing)*z.range, sin(z.bearing)*z.range, 0 ]';
    tlocE = R_BE'*R_SB'*tlocS + pstate.location + R_BE'*sstate.location;
    
    if is_scs == 0
    xy(:,j) = tlocE([1,2]);
    else
         xy(:,j) = tlocS([1,2]);
    end
    
end
