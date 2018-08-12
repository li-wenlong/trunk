function [ to, tr ] = cotranrevboth( ti, tj )
% COTRANREVBOTH finds two sets of coordinate transform parameters to directly convert
% a vector from i to j and j to i, given these implied by the location
% and azimuth vectors input to the function
%
% [ to, tr ] = cotranrevboth( ti, tj ) where ti and tj are coordinate transform
% parameters that specify transformations from Earth to i and j, respectively,
% returns the coordinate transfrom parameters that encodes the jth origin
% and its orientation at i in the array to, and, in the reverse direction, 
% the encoding of the origin and orientation of i at j in the array tr.

% Murat Uney 01/12/2017

to = zeros(size(ti));
tr = zeros(size(ti));


for i=1:size( ti, 2 )
    
    s_iE = ti( [1:2], i); % This is in earth
    alpha_i = ti( 3, i); % This is from earth to i
    
    s_jE = tj( [1:2],i ); % This is in earth
    alpha_j = tj( 3, i ); % This is from earth to j
    
    
    R_RE = dcm( alpha_j*pi/180, 0, 0 ); % Earth to remote (j)
    R_LE = dcm( alpha_i*pi/180, 0, 0 ); % Earth to local (i)
    
    [alpha_ifromj, th_ifromj, psi_ifromj] = idcm( R_LE*(R_RE') );  % az angle of i from j
    [alpha_jfromi, th_jfromi, psi_jfromi] =  idcm( R_RE*(R_LE') );  % az angle of j from i
    
    % Exclude the z directyon
    R_RE = R_RE([1:2],[1:2]);
    R_LE = R_LE([1:2],[1:2]); % = I

    R_LR = R_LE*(R_RE'); % Remote to local
    R_RL = R_LR'; % Local to remote
    
     
    to([1:2], i ) = R_LE*( s_jE-s_iE ); % line of sight from earth to i
    to(3, i) = alpha_jfromi*180/pi;
    
    tr([1:2], i) = R_RE*( -s_jE + s_iE ); % inverse line of sight from earth to j
    tr(3, i) = alpha_ifromj*180/pi;
    
end

