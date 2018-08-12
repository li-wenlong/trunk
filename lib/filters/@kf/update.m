function varargout = update( this, sensors , varargin )

this.parlhood = 1;

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

% Get the particles regarding the loc. dist. of the predicted intensity
m_pred = this.pred.m;
C_pred = this.pred.C;

[dim] = length(m_pred);


dimZ = length(this.Z(1).Z.Z );
% Get the likelihood matrices for all measurements
numsens = length(sensors);
H_ = zeros(numsens*dimZ,dim);
R_ = zeros(numsens*dimZ);
Z_ = [];
m_ = [];
C_ = zeros( numsens*dim );
I_ = [];
theta = [0,0]';

H4m_ = zeros(numsens*dimZ,dim*numsens);
for i=1:numsens
    m_i = m_pred;
    if i>=2
        m_i([1,2]) = m_i([1,2]) - varargin{1}([1,2], i-1 );
        theta = [theta; varargin{1}([1,2], i-1 ) ];
    end
    m_ = [m_; m_i];
    
    [I_E, H_E, R_E, T ] = innovations( sensors(i), this.Z(i), m_i );  
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

this.post = cpdf( gk( C_post,  m_post ) );

noise_density = cpdf( gk(  S_ ) );

this.parloglhood = noise_density.evaluatelog( I_ );
this.parlhood = exp( this.parloglhood ); % this.parlhood = noise_density.evaluate( I_ );
this.condpz = cpdf( gk( S_, H4m_*m_ ) ); % This is the conditional distribution in earth coordinate system
        

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