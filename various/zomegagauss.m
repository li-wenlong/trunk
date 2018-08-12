function z = zomegagauss( m1, C1, m2, C2, oms )


d = length(m1(:));

S1 = inv(C1);
S2 = inv(C2);

for cnt=1:length( oms )
    om = oms( cnt );
    
    fact1 = ( ( (2*pi)^(d/2) ) *det(C1)^((1-om)/2) *det(C2)^(om/2) )^-1;
    
    A = (1-om)*S1 + om*S2;
    B = (1-om)*m1'*S1 + om*m2'*S2 + (1-om)*m1'*S1' + om*m2'*S2';
    B = 0.5*B';
    
    fact2 = sqrt( (2*pi)^d/det(A) )*...
        exp( -0.5*(  (1-om)*m1'*S1*m1 + om*m2'*S2*m2  ) ...
        + 0.5*B'*inv(A)*B  );
    
    z(cnt) = fact1*fact2;
end

z = reshape( z, size(oms) );