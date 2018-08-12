function [C, m] = par2gauss(p)
% [C, m] = particles.par2gauss returns the mean and covariance matrix of 
% a single Gaussian that represents the particles without taking into 
% account the labels
% See par2gmm

 
myeps = 1.0e-8;
ndims = size(p.states,1);


mean_ = mean( p.states ,2 );

if size( p.states, 2) == 1
    pccov_ = myeps*eye(ndims);
else
    ws =  p.weights;
    
    
    cov_ = wcov( p.states, ws);
    
    if ~isempty(find(isnan(cov_)==1))||~isempty(find(isinf(cov_)==1))
        ws = ws + 0.001;
        ws = ws/sum(ws);
        cov_ = wcov( p.states(:, ind_ ), ws);
    end
    % Condition cov_
    [V,D] = eig( cov_ );
    
    svals = diag(D);
    svals( find( svals < myeps ) ) = myeps;
    
    ccov_ = V*diag(svals)*V';
    pccov_ = (ccov_ + ccov_')/2;
    
end
C = pccov_;
m = mean_;

