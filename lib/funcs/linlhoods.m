function [G, varargout] = linlhoods(x, z, H, R, varargin )
% linlhoods returns the likelihoods of the linear observation model
% G = linlhoods( x, z, H, R ) returns an array of likelihoods in G given
% the M d-dimensional states in x as an dxM array and P l-dims. observations 
% in z as a lxP array in accordance with the linear observation model
% characterised by H (lxd) and the noise covariance R (lxl).
%
% [G, I] = linlhoods( x, z, H, R ) returns the innovations z-Hx in I
% 
% [G, I] = linlhoods( x, z, H, R, P ) returns the likelihoods of the
% Gaussian components parameterised by the mean vectors x and covariance
% matrices P.

isP = 0;
if ~isempty(varargin{1})
    P = varargin{1};
    isP = 1;
end

numz = size( z, 2);
numcomp = size( x, 2);
dx = size(x, 1);
dz = size(z, 1);

G = zeros( numz, numcomp );
if isP
    % Find the likelihoods of the Gaussian components
    for i=1:numcomp
        % For the i th component
        
        % the covariance for the obs
        Pc = R(1:dz,1:dz) + H*P(:,:,i)*H';
        for j=1:numz
            % For the j th measurement
           I(j,i) = z(j) - H*x(:,i);
           G(j,i) = gauss_likelihood( I(j,i), Pc ); 
           
        end
    end
    
else
    % Find the likelihoods of the Gaussian components
    for i=1:numcomp
        % For the i th component
        for j=1:numz
            % For the j th measurement
           I(j,i) = z(j) - H*x(:,i);
           G(j,i) = gauss_likelihood( I(j,i), R ); 
           
        end
    end
       
end
if nargout>1
    varargout{1} = I;
end
