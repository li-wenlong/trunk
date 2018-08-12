function r = findrange2sensor( pars, varargin )
% function r = findrange2sensor( pars ) returns the range of input
% particles to the sensor.
% r = findrange2sensor( pars, sstate, pstate ) specifies the sensor's
% kinematic state with two @kstate objects sstate and pstate. sstate
% defines the kinematic state of the sensor with respect to the body
% coordinate frame of the platform it is mounted on, and pstate is the
% kinematic state of the platform with respect to a global frame.

sstate = kstate;
pstate = kstate;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'sstate'}
                if argnum + 1 <= nvarargin
                    sstate = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {'pstate'}
                if argnum + 1 <= nvarargin
                    pstate = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {''}
                
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        
    end
    argnum = argnum + 1;
end


        
plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );

[dpars, numpars] = size( pars );

r = zeros(numpars, 1);

% particles received in the ECS ; find them in the SCS

 
losE = [pars(:,:); zeros(max(0, 3- dpars), numpars)] - repmat( pstate.location + R_BE'*sstate.location,1, numpars );
losS = R_SB*R_BE*losE;
r = sqrt( sum( losS.*losS, 1) )';





