function bc = bcoeff( inp1 , inp2, varargin )
% function b = bcoeff( inp1 , inp2 )
% returns the Bhattacharyya coefficient of two distributions represented by
% particles

% Evaluat s_0(x) for P0 and P1
sig_ = 0; % This is the noise covariance to use during regularisation

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'sigma'}
                if argnum + 1 <= nvarargin
                    sig_ = varargin{argnum+1}(1);
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

if sig_ > eps
    % regularise the particles
    s0 = inp1.regwkde(sig_);
    s1 = inp2.regwkde(sig_);
end

numP0 = s0.getnumpoints;
numP1 = s1.getnumpoints;

[evals0, assocwP0] = s0.evaluate( [s0.getstates, s1.getstates] );
[evals1, assocwP1] = s1.evaluate( [s0.getstates, s1.getstates] );

s0atP0 = evals0(1:numP0); 
s0atP1 = evals0(numP0+1:numP0 + numP1);

s1atP0 = evals1(1:numP0); 
s1atP1 = evals1(numP0+1:numP0 + numP1);  

bc =  estz( s0atP0, s0atP1, s1atP0, s1atP1, 0.5 );

end

function z = estz( s0atP0, s0atP1, s1atP0, s1atP1, omega_ )
% z = esz( s0atP0, s0atP1, s1atP0, s1atP1, omega_ ) returns a Monte Carlo
% estimate for z = \int s_0^(1-omega)(x) s_1^omega(x)dx
% Let P0 ~ s_0(x) and P1 ~ s_1(x)
% s0atP0 = { s_0(x) evaluated for x \in P0 }
% s0atP1 = { s_0(x) evaluated for x \in P1  }
% s1atP0 = { s_1(x) evaluated for x \in P0 }
% s1atP1 = { s_1(x) evaluated for x \in P1 }


numelP0 = length(s0atP0);
numelP1 = length(s0atP1);

denomP0 = s0atP0*numelP0/(numelP1 + numelP0) + s1atP0*numelP1/(numelP1 + numelP0);
denomP1 = s0atP1*numelP0/(numelP1 + numelP0) + s1atP1*numelP1/(numelP1 + numelP0);

% Find the estimate of z
sumP0 = sum( ( s0atP0.^(1-omega_) ).*( s1atP0.^omega_ )./( denomP0 ) );
sumP1 = sum( ( s0atP1.^(1-omega_) ).*( s1atP1.^omega_ )./( denomP1 ) );

z = ( sumP0 + sumP1 )/(numelP0 + numelP1);
end

