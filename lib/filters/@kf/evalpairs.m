function [parloglhoods, varargout] = evalpairs( this, sensors , varargin )

if isempty( this.pred )
   if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
        if nargout>=2
            varargout{2} = this.parlhood;
        end
    end
    return;
end

% First, evaluate the likelihood of pairing a prediction in hand with the
% measurements in hand



% We assume number of tracks = N = number of measurements (i.e., prob. of
% birth for t>1 = 0; and prob. of survival = 1; P_D = 1 and P_FA = 0

%number of "tracks"
N = length( this.pred );
% Number of "measurements"
M = length( this.Z.Z );

posts = gk;
condpzs = gk;
parloglhood = [];
parlhoods = [];

for icnt = 1:N
    pred_dist = this.pred( icnt );
    
    % Get the particles regarding the loc. dist. of the predicted intensity
    m_pred = pred_dist.m;
    C_pred = pred_dist.C;
    [dim] = length(m_pred);
    
    for jcnt = 1:M
        
        apcnt = (icnt-1)*N + jcnt;% association pair counter
        
        Zj = this.Z(1).Z(jcnt);
        dimZ = length(Zj.Z );
        % Get the likelihood matrices for all measurements
        numsens = 1; 
        H_ = zeros(numsens*dimZ,dim);
        R_ = zeros(numsens*dimZ);
        Z_ = [];
        m_ = [];
        C_ = zeros( numsens*dim );
        I_ = [];
        theta = [0,0]';
        
        H4m_ = zeros(numsens*dimZ,dim*numsens);
        for i=1:numsens
            if i==2
               error('Multisensor filtering with association is not implemented yet!') 
            end
            m_i = m_pred;
            if i>=2
                m_i([1,2]) = m_i([1,2]) - varargin{1}([1,2], i-1 );
                theta = [theta; varargin{1}([1,2], i-1 ) ];
            end
            m_ = [m_; m_i];
            
            [I_E, H_E, R_E, T ] = innovations( sensors(i), this.Z(i), m_i, Zj );
            % Here, _E indicates that the quantities are in the Earth Coordinate
            % System
            % If there is a single sensor with insensorframe flag set, then _E will
            % be the Sensor Coordinate System.
            [d1,d2] = size(H_E);
            
            H_E = [H_E, zeros( dimZ , dim-d2 ) ];
            H_( (i-1)*dimZ + 1:(i-1)*dimZ + dimZ, : ) = H_E;
            H4m_( (i-1)*dimZ + 1:(i-1)*dimZ + dimZ, (i-1)*dim + 1:(i-1)*dim + dim  ) = H_E;
            
            R_( (i-1)*dimZ + 1:(i-1)*dimZ + dimZ, (i-1)*dimZ + 1:(i-1)*dimZ + dimZ ) = R_E;
            
            % This is the multi sensor innovation in the ECS
            I_ = [ I_ ; I_E ];
        end
        
        
        S_ = H_*C_pred*H_' + R_;
        
        % Kalman Gain
        K = C_pred*H_'*inv( S_ );
        
        m_post = m_pred + K*I_;
        C_post = ( eye(dim) - K*H_ )*C_pred;
        
        posts( apcnt ) = cpdf( gk( C_post,  m_post ) );
        
        noise_density = cpdf( gk(  S_ ) );
        
        parloglhoods( apcnt ) = noise_density.evaluatelog( I_ );
        parlhoods( apcnt ) = exp( parloglhoods( apcnt ) ); % this.parlhood = noise_density.evaluate( I_ );
        condpzs( apcnt ) = cpdf( gk( S_, H4m_*m_ ) ); % This is the conditional distribution in earth coordinate system
        
    end
end

if nargout >= 2
    varargout{1} = parlhoods;
    if nargout>=3
        varargout{2} = posts;
    end
    if nargout >=4
        varargout{3} = condpzs;
    end
end