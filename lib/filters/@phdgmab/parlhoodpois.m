function [lhood, varargout] = parlhoodpois( this, predintensity, sensor )

Z = this.Z; % get the observation set

Zk_len = length(Z.Z);
P_D = this.probdetection;
lambda_c = sensor.clutter.getlambda;
meas.P_D = this.probdetection;
meas.clutterint = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);


this.proddenum = 1;
this.sumdenum = 0;

% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = predintensity.s.gmm.w*predintensity.mu ;
% Predicted gaussian kernels
pgks = predintensity.s.gmm.pdfs;



this.sumdenum = 0;
this.proddenum = 1;
loglhood = 0;
%Update the weights
w_upd_comp = zeros(length(w_pred), Zk_len);

[dimX] = pgks(1).getdims;
dimZ =  length( Z.Z(1).Z );

this.parloglhood = -lambda_c -predintensity.mu*P_D;
this.parlhood = exp( -lambda_c - P_D*predintensity.mu );

for i=1:Zk_len

    for j = 1:length(pgks )
        m_pred = pgks(j).m;
        C_pred = pgks(j).C;
        
        [I_E, H_E, R_E, T ] = innovations( sensor, Z , m_pred, Z.Z(i) );
        
        [d1,d2] = size(H_E);
        
        H_E = [H_E, zeros( dimZ , dimX-dimZ ) ];
            
        S_ = H_E*C_pred*H_E' + R_E;
        invS = inv( S_ );
        % Kalman Gain
        K = C_pred*H_E'*invS;
        
        % The lines below spend too much time, instead, we implement them
        % explicitly
        % pz = cpdf( gk(  S_  , H_E*m_pred) );
        % q_z = pz.evaluate( Z.Z(i).Z );
        
        q_z = (1/sqrt(det( 2*pi*S_)))*exp( -0.5*( I_E )'*invS*( I_E ) );
        
        
        m_post = m_pred + K*I_E;
        C_post = ( eye(dimX) - K*H_E )*C_pred;       
        
        w_upd_comp(j,i) = P_D*q_z*w_pred(j);
        
        
     
    end
    this.sumdenum(i) = sum( w_upd_comp(:,i) ) + meas.clutterint(i);
    
    % parameter likelihood stuff
    this.proddenum = this.proddenum*this.sumdenum(i);
    this.parloglhood = this.parloglhood + log( this.sumdenum(i) );
    this.parlhood = this.parlhood*this.sumdenum(i);
    % -----
    
    % normalise the weights
    w_upd_comp(:,i) = w_upd_comp(:,i)/this.sumdenum(i); 
    
end
lhood = this.parlhood;
loglhood = this.parloglhood;
if nargout >1
    varargout{1} = loglhood;
end