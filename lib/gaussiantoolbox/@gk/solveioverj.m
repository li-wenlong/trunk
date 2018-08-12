function x_star = solveioverj( gki , gkj , varargin )

if nargin >=3
    sc = varargin{1}(1);
end

% Numerator
m2 = get( gki, 'm' );
S2 = get( gki, 'S' );

Zi = get( gki, 'Z' );
% Denominator
m1 = get( gkj, 'm' );
S1 = get( gkj, 'S' );

Zj = get( gkj, 'Z' );

sc_ = 2*log( sc*Zj/Zi );

% syms m1 m2 S1 S2 alpha

% x = alpha*m1 + (1-alpha)*m2

% e = (x-m1)'*S1*(x-m1) - (x-m2)'*S2*(x-m2)

%(conj(alpha*m1+(1-alpha)*m2-m1)*S1*(m1-m2)-conj(alpha*m1+(1-alpha)*m2-m2)*S2*(m1-m2))*alpha+conj(alpha*m1+(1-alpha)*m2-m1)*S1*(m2-m1)
A = m1'*S1*m1 - m1'*S1*m2 - m2'*S1*m1 + m2'*S1*m2 - m1'*S2*m1 + m1'*S2*m2 + m2'*S2*m1 - m2'*S2*m2;
B = m1'*S1*m2 + m2'*S1*m1 -2*m2'*S1*m2 - m1'*S2*m2 - m2'*S2*m1 + 2*m2'*S2*m2 - m1'*S1*m1 + m1'*S1*m2 + m2'*S2*m1...
    - m2'*S2*m2 - m1'*S1*m1 + m2'*S1*m1 + m1'*S2*m2 - m2'*S2*m2;
C = m2'*S1*m2 - m2'*S2*m2 - m1'*S1*m2 + m2'*S2*m2 - m2'*S1*m1 + m2'*S2*m2 + m1'*S1*m1 - m2'*S2*m2;

alphas = roots([ A, B, C-sc_]);

imagalphas = imag(alphas);
realalphas = find( abs(imagalphas)<eps );
if ~isempty( realalphas  )
    [ ind1 ] = find( abs( alphas( realalphas) ) <=1 & abs( alphas( realalphas ) ) >=0 );
    if isempty(ind1)
        error('No roots between 0 and 1...');
    else
        x_star = m1* real( alphas( realalphas(ind1(1))) ) + (1- real( alphas( realalphas(ind1(1))) ) )*m2;
    end
    
else
    error('No real roots for equation: Possibly caused by mis-selection of the scale!');
end

