function rdiv = renyidiv( cl, varargin )


alphaval = 0.5;
card0 = cl.card;
card1 = cl.card;
s1 = cl.s;


nvarargin = length(varargin);
argnum = 1;

while argnum<=nvarargin
    if isa( lower(varargin{argnum}), 'char')
        switch lower(varargin{argnum})
            case {'alpha'}
                if argnum + 1 <= nvarargin
                    alphaval = varargin{argnum+1};
                    argnum = argnum + 1;
                end
                
            otherwise
                error('Wrong input string');
        end
    elseif isa( lower(varargin{argnum}), 'numeric')
        if~isempty( varargin{argnum} )
            card1 = varargin{argnum};
        end
    elseif isa( lower(varargin{argnum}), 'pdf')
        s1 = varargin{argnum};
    elseif isa( lower(varargin{argnum}), 'phd')
        s1 = varargin{argnum}.s;
    end
    argnum = argnum + 1;
end

% Evaluat s_0(x) for P0 and P1
%sig_ = 10; % This is the noise covariance to use during regularisation
%s0 = cl.s.particles.regwkde(sig_);
%s1 = s1.particles.regwkde(sig_);

s0 = cl.s.particles;
s1 = s1.particles;


numP0 = s0.getnumpoints;
numP1 = s1.getnumpoints;

[evals0, assocwP0] = s0.evaluate( [s0.getstates, s1.getstates] );
[evals1, assocwP1] = s1.evaluate( [s0.getstates, s1.getstates] );

s0atP0 = evals0(1:numP0);
s0atP1 = evals0(numP0+1:numP0 + numP1);

s1atP0 = evals1(1:numP0);
s1atP1 = evals1(numP0+1:numP0 + numP1);


if ~ abs( alphaval-1 )<eps
    
    rdiv = mcrenyi( s0atP0, s0atP1, s1atP0, s1atP1, card0, card1, alphaval );
    
else
    rdiv1 = mcrenyi( s0atP0, s0atP1, s1atP0, s1atP1, card0, card1,  1 + 0.0005 );
    rdiv2 = mcrenyi( s0atP0, s0atP1, s1atP0, s1atP1, card0, card1,  1 - 0.0005 );
    rdiv = (rdiv1+rdiv2)/2;
    
end

end


function rdiv = mcrenyi( s0atP0, s0atP1, s1atP0, s1atP1, card0, card1, alphaval )


ns = [0:min( length(card0), length(card1) )-1]';

zest =  estz( s0atP0, s0atP1, s1atP0, s1atP1, alphaval );
rdiv = (1/( alphaval-1) )*log( sum(  (card0.^alphaval).*(card1.^(1-alphaval)).*...
    (zest.^ns) )  );




end
function z = estz( s0atP0, s0atP1, s1atP0, s1atP1, alphaval )
% z = esz( s0atP0, s0atP1, s1atP0, s1atP1, omega_ ) returns a Monte Carlo
% estimate for z = \int s_0^(1-omega)(x) s_1^omega(x)dx
% where omega = 1-alpha
% Let P0 ~ s_0(x) and P1 ~ s_1(x)
% s0atP0 = { s_0(x) evaluated for x \in P0 }
% s0atP1 = { s_0(x) evaluated for x \in P1  }
% s1atP0 = { s_1(x) evaluated for x \in P0 }
% s1atP1 = { s_1(x) evaluated for x \in P1 }

omega_ = 1-alphaval;

numelP0 = length(s0atP0);
numelP1 = length(s0atP1);

denomP0 = s0atP0*numelP0/(numelP1 + numelP0) + s1atP0*numelP1/(numelP1 + numelP0);
denomP1 = s0atP1*numelP0/(numelP1 + numelP0) + s1atP1*numelP1/(numelP1 + numelP0);

% Find the estimate of z
sumP0 = sum( ( s0atP0.^(1-omega_) ).*( s1atP0.^omega_ )./( denomP0 ) );
sumP1 = sum( ( s0atP1.^(1-omega_) ).*( s1atP1.^omega_ )./( denomP1 ) );

z = ( sumP0 + sumP1 )/(numelP0 + numelP1);
end