function [ to ] = cotranrev( tj )
% COTRANREV finds a set of coordinate transform parameters to directly convert
% a vector from j to i, given location and azimuth vectors of reference i
% input to the function
%
% trev = cotranrev( t ) where t = ( [s_j]_i, [\alpha_j]_i ) is the
% coordinate transform from i to j with []_i indicating the reference frame
% i, returns the transform from reference frame j to i, i.e., ( [ s_i =
% -s_j ]_j, [\alpha_i]_j )

% Murat Uney 01/12/2017

to = zeros(size(tj));
for i=1:size( tj, 2 )
    s_j = tj( [1:2],i );
    alpha_j = tj( 3, i );
    
    R_RE = dcm( alpha_j*pi/180, 0, 0 ); % Earth to remote
    R_LE = dcm( 0, 0, 0 ); % Earth to local = I
    
    % Exclude the z directyon
    R_RE = R_RE([1:2],[1:2]);
    R_LE = R_LE([1:2],[1:2]); % = I

    R_LR = R_LE*(R_RE'); % Remote to local = R_RE'
    R_RL = R_LR'; % R_RE
    
    s_i = R_LR*( - s_j ); % R_RE*s_j
    alpha_i = -alpha_j;
    
    to([1:2], i ) = s_i;
    to(3,i) = alpha_i;
end

