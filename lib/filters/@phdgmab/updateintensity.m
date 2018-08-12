function varargout = updateintensity( this, sensor, varargin )

Z = this.Z; % get the observation set

Zk_len = length(Z.Z);
P_D = this.probdetection;
lambda_c = sensor.clutter.getlambda;
meas.P_D = this.probdetection;
meas.clutterint = sensor.getclpdf(Z.Z);%1/(pi*sensor.maxrange^2);
flt_param.N_max = length( this.postcard )-1;
%cdn_pred = this.predcard;
this.proddenum = 1;
this.sumdenum = 0;

if isempty( this.predintensity )
    % nothing to update, return:
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
        if nargout>=2
            varargout{2} = this.proddenum;
        end
    end
    return;
end

% Get the components and weights for the loc. dist. of the predicted intensity
w_pred = this.predintensity.s.gmm.w*this.predintensity.mu;

% Predicted gaussian kernels
pgks = this.predintensity.s.gmm.pdfs;

if nargin>=3
    for i=1:length( pgks )
        pgks(i).m([1,2]) = pgks(i).m([1,2])  - varargin{1}([1,2]);
    end
end

this.sumdenum = 0;
this.proddenum = 1;
loglhood = 0;
%Update the weights
w_upd_comp = zeros(length(w_pred), Zk_len);
post_gks(1:length(w_pred), 1:Zk_len) = gk;
[dimX] = pgks(1).getdims;
dimZ =  length( Z.Z(1).Z );

this.parloglhood = -lambda_c -this.predintensity.mu*P_D;
this.parlhood = exp( -lambda_c - P_D*this.mupred );

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
        
        % The below lines comsume too much time so we explicitly carry them
        % out in the following line finding q_z
        % pz = cpdf( gk(  S_  , H_E*m_pred) );
        % q_z = pz.evaluate( Z.Z(i).Z );
        
        q_z = (1/sqrt(det( 2*pi*S_)))*exp( -0.5*( I_E )'*invS*( I_E ) );
        
         
        m_post = m_pred + K*I_E;
        C_post = ( eye(dimX) - K*H_E )*C_pred;       
        
        w_upd_comp(j,i) = P_D*q_z*w_pred(j);
        
       
        % The line below is time costly. Implemented directly in the
        % following lines
        % post_gks(j,i) = cpdf( gk( C_post, m_post ));
        
        post_gks(j,i).m = m_post;
        post_gks(j,i).C = C_post;
        post_gks(j,i).S = inv( C_post );
        post_gks(j,i) = cpdf( post_gks(j,i) );
        
    end
    this.sumdenum(i) = sum( w_upd_comp(:,i) ) + meas.clutterint(i);
    
    % parameter likelihood stuff
    this.proddenum = this.proddenum*this.sumdenum(i);
    this.parloglhood = this.parloglhood + log( this.sumdenum(i) );
    this.parlhood = this.parlhood*this.sumdenum(i);
    % -----
    
    % normalise the weights
    if this.sumdenum(i) > eps
        w_upd_comp(:,i) = w_upd_comp(:,i)/this.sumdenum(i); 
    else
        w_upd_comp(:,i) = w_upd_comp(:,i)*0;
    end  
end
    

w_upd_comp(:,Zk_len+1) =  w_pred * (1-P_D);

this.mupost = sum( sum( w_upd_comp ) );

post_gmm = gmm( w_upd_comp(:), [ post_gks(:); pgks(:)] );
post_gmm = prgmm(post_gmm, 1.0e-8, 2/3, this.maxnumcomp );

this.postintensity = phd;
this.postintensity.mu = this.mupost;
this.postintensity.s.gmm = post_gmm ;

this.postcard  =  poisspdf([0:length(this.postcard)-1], this.mupost )';



if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
    if nargout>=2
        varargout{2} = this.proddenum;
    end
    
end
