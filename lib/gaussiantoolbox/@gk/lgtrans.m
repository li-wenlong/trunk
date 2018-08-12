function d = lgtrans( these, F, Q )

d = these;
for i = 1:length( these )
    d(i) = cpdf( gk( F*these(i).C*F' + Q, F*these(i).m ) );
end
