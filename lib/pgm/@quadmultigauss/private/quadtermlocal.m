function [ esi, erij, sf  ] = quadtermlocal( predi, posti, taui, Zi, Hi, Ri, predj, postj, theta_i, theta_j, Hj, Rj )




% local posterior ordered
postitaui = posti(taui);

% A) Find s_i in the Zi centric order

% A.i) Reorder local predictions in the ordering associated with the measurements
preditaui = predi(taui);

% A.ii) Find the measurement distributions
si = measdist( preditaui, Hi, Ri );

% B) Find r_ij

% B.i) Transform and reorder the remote posterior
postjati = cotranx2y( postj, theta_j, theta_i  );


% B.ii) Solve the identity problem
[A, condpz ] = assocmat( postjati, Zi, Hi, Ri );

% Below code finds the associations from posteriors to Zi
invgamma_mat = Hungarian( -A );
invgamma_hat = mat2perm( invgamma_mat );
% Find from Zi to posteriors
gamma_hat = invperm( invgamma_hat );

% B.iii) Find  p(z^i_k | z^j_{1:k}, \theta ) s in the required order
rij = condpz( gamma_hat ) ; % These are the distributions in Zi order

% C) Find the scale factor

% C.ii) Transform the local posterior to the remote coordinate frame
postiatj = cotranx2y( postitaui, theta_i, theta_j  );
prediatj = cotranx2y( preditaui, theta_i, theta_j  );

postjatitaui =  postjati( gamma_hat );

predjtaui = predj( gamma_hat );
predjatitaui = cotranx2y( predjtaui, theta_j, theta_i  );

pzsGi = cpdf( diag( [ measdist( preditaui, Hi, Ri ), measdist( postiatj, Hj, Rj )] ) );

% Below we find p(zi|zj_{1:k})p(zj_k|zj_{1:k-1})
pzsGj = cpdf( diag( [measdist( postjatitaui, Hi, Ri ), measdist( predjtaui, Hj, Rj ) ] ) );

% evaluate the scale factor
sf = geomeanscale( pzsGi, pzsGj );

% D) Evaluate si
esi = 0;
for cnt=1:length( si )
    esi = esi + si( cnt ).evaluatelog( Zi(:, cnt ) );
end

% E) Evaluate rij
erij = 0;
for cnt=1:length( rij )
    erij = erij + rij(cnt).evaluatelog( Zi(:, cnt) );
end





