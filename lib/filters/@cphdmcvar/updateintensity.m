function varargout = updateintensity( this, sensor )

%p = particle('state',[-3555/2 3555/2 0 0],'weight',1,'label','p');
%nbp = particle('state',[3555/2 3555/2 0 0],'weight',1,'label','nb');
%this.predintensity = p;
%this.postintensity = [p,nbp];


Z = this.Z;
Zk_len = length(Z.Z);

lambda_c = sensor.clutter.getlambda;
meas.clutterpdf = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);

flt_param.N_max = length( this.postcard )-1;
flt_param.rho = this.numpartpersist;
flt_param.Lmax = this.maxnumpart;
cdn_pred = this.predcard;

if isempty( this.predintensity )
   if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end

% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = this.predintensity.s.particles.getweights...
    *this.predintensity.mu ;
p = this.predintensity.s.particles.getstates;

if isfield( sensor, 'pdprofile' )
    P_D = sensor.pdprofile.getpdprofile( findrange2sensor( p, Z.sstate, Z.pstate  ) );
else
    pdcfg = pdprofilelindeccfg;
    pdcfg.pdatzero = sensor.pd;
    pdcfg.pdfar = sensor.pd;
    pdcfg.range = sensor.maxrange;
    pdcfg.threshold = pdcfg.range/2;
    
    pdlindec = pdprofilelindec( pdcfg );
    
    P_D = pdlindec.getpdprofile( findrange2sensor( p([1,2],:), Z.sstate, Z.pstate ) );
   
end
P_D( P_D == 1 ) = 0.9999; % Otherwise, there will be some particles with zero updated weight
% and we need to prune them before going ahead with regularisation (i.e.,
% kde+resampling)
P_D = P_D(:);
% Likelihood function matrix
Gk = sensor.likelihood( Z, p );

% Elementary symmetric function computations:
% 1) Find Integrals of Pd(x)*g(z|x)*v(x) for each z
intpdgv = zeros(Zk_len,1); % this is the array to hold the integrals
for i=1:Zk_len
    intpdgv(i) = sum( P_D.*Gk(i,:)'.*w_pred );
end

% 2) scale with the clutter localisation density evaluated at the
% measurements, i.e. zval(i) = (1/s_c(z(i)) * intpdgv( z(i) )
zvals = intpdgv./meas.clutterpdf ;

% 3) Find the elementary symmetric functions of order 0,1,...,n
% esfvals[j] = e_j( \Xi( D_{k|k-1}, Z ) s
esfvals = sumesf(zvals);        

% 4) Elementary symmetric functions for removed observations
% esfvals_D[j,i] = e_j( \Xi( D_{k|k-1}, Z\{z_i} )
esfvals_D = zeros(Zk_len,Zk_len);
for i=1:Zk_len
    esfvals_D(:,i) = sumesf([zvals(1:i-1);zvals(i+1:Zk_len)]);
end

% 5) Elementary symmetric functions for removed two observations
% esfvals_E(j, i ) = e_j( \Xi( D_{k|k-1}, Z_k\Z_i )
% where Z_i is a two-element subset of Z_k
if Zk_len >= 2
    num2subsets = nchoosek( Zk_len, 2 );
else
    num2subsets = 0;
end
twosubsets = subsets1( [1:Zk_len], 2 )';

esfvals_E = zeros( Zk_len, num2subsets );

for i=1:num2subsets
    Zkdiff = setdiff( [1:Zk_len], twosubsets{i} );
    esfvals_E( 1:Zk_len-1, i ) = sumesf( zvals( Zkdiff ) );
end
    

% cardinality of clutter
cdn_K = poisspdf([0:max(flt_param.N_max,Zk_len)],lambda_c);
% predicted number of objects (integral of pred PHD)

% Computation of Upsilon 0 and 1
Ups0 = zeros(flt_param.N_max+1,1);
Ups1 = zeros(flt_param.N_max+1,1);
Ups2 = zeros(flt_param.N_max+1,1);

nu_pred = sum(w_pred);
fapred = sum( w_pred.*(1 - P_D ) );

% Get new born particle weights
if ~isempty( this.nbintensity )
    nu_nb  = this.nbintensity.mu;
else
    nu_nb  = 0;
end

for n=0:flt_param.N_max
    for j=0:min(Zk_len,n)
        Pnj0 = this.Pcoef( n+1,j+1 ) ;%permcoeff( n, j ); % prod([n-j+1:n]);
        Pnj1 = this.Pcoef( n+1,j+1 + 1 ); %permcoeff( n, j + 1 ); %prod([n-(j+1)+1:n]);
        Pnj2 = this.Pcoef( n+1,j+1 +2 );% permcoeff( n, j + 2 ); % prod([n-(j+2)+1:n]);
             
        if Zk_len-j > length( this.factor )
            facterm = factorial(Zk_len-j) ;
        elseif Zk_len-j <0
            facterm = 0;
        else
            facterm = this.factor( Zk_len - j + 1);
        end
        
        Ups0(n+1) = Ups0(n+1)+ facterm * cdn_K(Zk_len-j+1) * ...
            Pnj0 *( fapred^(n-j) /(nu_pred+nu_nb)^n) ...
            * esfvals(j+1);
        
        Ups1(n+1) = Ups1(n+1)+ facterm * cdn_K(Zk_len-j+1) * ...
            Pnj1 * ( fapred^(n-j-1)/(nu_pred+nu_nb)^n) ...
            * esfvals(j+1);
        
        Ups2(n+1) = Ups2(n+1) + facterm * cdn_K(Zk_len-j + 1)*...
            Pnj2 * ( fapred^(n-j-2)/(nu_pred+nu_nb)^n ) ...
            * esfvals( j + 1);
            
    end
end
% Computation of Upsilon 1 and 2 for removed obs
Ups1_D = zeros(flt_param.N_max+1,Zk_len);
Ups2_D = zeros(flt_param.N_max+1,Zk_len);

for i=1:Zk_len
    for n=0:flt_param.N_max
        for j=0:min(Zk_len-1,n)
           Pnj1 = this.Pcoef( n+1,j+1  + 1 ); %permcoeff( n, j + 1 ); %prod([n-(j+1)+1:n]);
           Pnj2 = this.Pcoef( n+1,j+1  + 2 );% permcoeff( n, j + 2 ); % prod([n-(j+2)+1:n]);
        
           if Zk_len-j-1 + 1 > length( this.factor )
               facterm = factorial(Zk_len-j -1 ) ;
           elseif Zk_len - j -1 + 1<0
               facterm = 0;
           else
               facterm = this.factor( Zk_len - j -1 + 1);
           end
           
           if Zk_len-1-j+1 <= 0
               cdnterm = 0;
           else
               cdnterm = cdn_K(Zk_len-1-j+1);
           end
             
            Ups1_D(n+1,i) = Ups1_D(n+1,i)+ facterm * cdnterm * ...
                Pnj1 * ( fapred^(n-j-1)/(nu_pred+nu_nb)^n) ...
                * esfvals_D(j+1,i);
            
            Ups2_D(n+1,i) = Ups2_D(n+1,i)+ facterm * cdnterm*...
                Pnj2 * ( fapred^(n-j-2)/(nu_pred+nu_nb)^n) ...
                * esfvals_D(j+1,i);
        end
    end
end
% Computation of Ups 2 for removal of two observations
Ups2_E = zeros(flt_param.N_max+1, num2subsets );

for i=1:num2subsets
    for n=0:flt_param.N_max
        for j=0:min(Zk_len-2,n)
            Pnj2 = this.Pcoef( n+1,j+1 +2 );% permcoeff( n, j + 2 ); % prod([n-(j+2)+1:n]);
            
            if Zk_len-j -2 + 1 > length( this.factor )
                facterm = factorial(Zk_len-j -2) ;
            elseif Zk_len-j -2 + 1<0
                facterm = 0;
            else
                facterm = this.factor( Zk_len - j -2 + 1);
            end
            
            if Zk_len-2-j+1 <= 0
                cdnterm = 0;
            else
                cdnterm = cdn_K(Zk_len-2-j+1);
            end
            
            Ups2_E(n+1,i) =  Ups2_E(n+1,i) + facterm * cdnterm*... 
                Pnj2 * ( fapred^(n-j-2)/(nu_pred+nu_nb)^n)...
                * esfvals_E(j+1,i);
        end
    end
end

% Updated cardinality
cdn_pred = (cdn_pred + 1e-20)/(sum(cdn_pred + 1e-20));
denom = sum( Ups0.* cdn_pred );

cdn = Ups0 .* cdn_pred / denom;


% Find L_1(\emptyset)
L_1_emptyset = sum( Ups1.* cdn_pred )/denom;
L_2_emptyset = sum( Ups2.* cdn_pred )/denom;
L_1_z = zeros( Zk_len, 1);
L_2_z = zeros( Zk_len, 1);
% Find L_1(z)
for i=1:Zk_len
    L_1_z(i) = sum( Ups1_D(:, i).* cdn_pred )/denom;
    L_2_z(i) = sum( Ups2_D(:, i).* cdn_pred )/denom;
end

L_2_zz = zeros( num2subsets, 1);
% Find L_2( twosubsets{i} )
for i=1:num2subsets
    L_2_zz( i ) = sum( Ups2_E( :, i).* cdn_pred )/denom;
end

%Updated weights and particles
w_upd_comp = zeros(length(w_pred),Zk_len+1);
% First, find the unscaled update terms

for i=1:Zk_len
    w_upd_comp(:,i) = ( ( P_D.*Gk(i,:)').*w_pred )/meas.clutterpdf(i);
end
w_upd_comp(:,Zk_len+1) =  w_pred .* (1-P_D);

% Integrate P(z|x)D_k|k-1(x)/s(z) terms and P(\emptyset|x)D_k|k-1(x) over bounded regions Bs
intvals = [];
if ~isempty( this.regions )
    if isa( this.regions, 'region' )
        numregs = length( this.regions );
        intvals = zeros( numregs, Zk_len+1 );
        for j=1:numregs
            for i=1:Zk_len
                intvals(j, i ) = this.regions( j ).parint( p([1,2], : ), w_upd_comp(:,i) );
            end
            intvals(j, Zk_len + 1 ) = this.regions( j ).parint( p([1,2], : ), w_upd_comp(:,Zk_len+1));
        end
    end
end
% Scale the update terms
for i=1:Zk_len
    w_upd_comp(:,i) = w_upd_comp(:,i)* L_1_z(i);
end

w_upd_comp(:,Zk_len+1) = w_upd_comp(:,Zk_len+1)* L_1_emptyset;

% MU:
% Here we sort the contribution of each measurement to each particle and
% achieve a clustering:
[maxCont, clusterIndx] = max( w_upd_comp(:,1:Zk_len+1)' );
clusterIndx( find(clusterIndx==Zk_len+1 ) )=0;

w_upd = sum(w_upd_comp,2)';

% Now, find the variances in the specified regions
if ~isempty( intvals )
    
  % First, find the integral of the updated intensity
  term0s = [];
  for i=1:numregs
      term0s(i) = this.regions( i ).parint( p([1,2], : ), w_upd);
  end
  
   % Find the first terms 
   term1s = [];
   for i=1:numregs
      term1s(i) = intvals( i, Zk_len + 1 )^2*( L_2_emptyset - L_1_emptyset^2 );
   end
   
   % Find the second terms
   term2s = [];
   for i=1:numregs
       term2s(i) = 2*intvals( i, Zk_len + 1 )* sum( intvals( i, 1:Zk_len ).*( L_2_z' - L_1_z'*L_1_emptyset)  );
   end
   
   % Find the third terms
   term3s = [];
   for i=1:numregs
       term3s(i) = 0;
       for j = 1:num2subsets
           term3s(i)  = term3s(i) + ...
               intvals(i, twosubsets{j}(1) )*intvals(i, twosubsets{j}(2) )*...
               ( L_2_zz( j ) - L_1_z( twosubsets{j}(1) )*L_1_z( twosubsets{j}(2) ) );
       end
   end
   
   term4s = [];
   for i=1:numregs
       term4s(i) = sum( ( intvals( i, 1:Zk_len ).^2).*(L_1_z'.^2) ); 
   
       
   end
   vars = term0s + term1s + term2s + 2*term3s -term4s;
   this.vars = vars;
   this.mus = term0s;
end

% resampling
hat_N_soft = sum(w_upd);
if hat_N_soft> 0.05, %resamplingUpdatePersistent2.m
    persupdate = this.predintensity.s.particles;
    persupdate = persupdate.sublabels( clusterIndx );
    persupdate = persupdate.subweights( w_upd/hat_N_soft );
    
    
    if this.regflag
        % persupdate = persupdate.updatekdebws('nonsparse','dims','all'); % Here, the BWs are found
        % NOTE: If the velocity components are generated by a mixture by the
        % adaptive new born target process, then the dims above should be
        % [1,2]'
     %   if this.veldist.getnumcomp==1
            persupdate = persupdate.updatekdebwsblabh('nonsparse'); % Here, the BWs are found
      %  else
      %      persupdate = persupdate.updatekdebws('nonsparse','dims',[1,2]'); % Here, the BWs are found
      %  end
    end
    
    % Resample 
    Lk= min(round(hat_N_soft*flt_param.rho),flt_param.Lmax);
    [persupdate, resindx] = persupdate.resample(Lk);
   
    if this.regflag
        persupdate = persupdate.regwkde(this.regvar);
    end
   
    
    
    persupdate = persupdate.inchist; % increase the history length by one
    
    this.postintensity = phd;
    this.postintensity.mu = hat_N_soft;
    
    this.postintensity.s.particles = persupdate;
    this.postintensity.s.kdes = [];
    this.postintensity.s.gmm = [];
    this.resindx = resindx;
    this.postcard  =cdn;
else
   % this.postintensity = this.predintensity;
   % this.postcard  =cdn;
end



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end