function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn )

% obs is an sreport object
Zs = obs.Z; % Zs are mlinmeas objects

pstate = obs.pstate;
sstate = obs.sstate;

if this.insensorframe == 0
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
end

nbstates_ = [];%zeros(2,length(Zs)*numpartnewborn );
labels = [];%zeros(1, length(Zs)*numpartnewborn );

numins = 0;
for i=1:length(Zs)
    
    % In sensor coordinate system
    myobs = Zs(i).Z;
    
    if isempty(myobs)
        continue;
    end
    % Fit an ellipse and find the center
    elparam = fitellipse( myobs(1,:),myobs(2,:));
    Cx = elparam(1);
    Cy = elparam(2);
    Rx = elparam(3); % Use Rx and Ry as measures of uncertainty
    Ry = elparam(4);
    alpha_ = elparam(5);
    
    mvec = mean( myobs, 2 );
        
    R = [cos(alpha_), -sin(alpha_); sin(alpha_), cos(alpha_)];
    Cm = R*this.P([1,2],[1,2]);
    
    if norm( mvec-[Cx;Cy] )> 750
        Cx = mvec(1);
        Cy = mvec(2);
    end
    
    numpars = numpartnewborn;
    losSxy = repmat( [Cx,Cy]',1, numpars ) + sqrtm(Cm)*randn(2, numpars);
    losS = [losSxy; zeros(1, numpars) ];
    
    
    
    % Observations in Earth
    myobsE = repmat(plocE,1, size(myobs, 2) )...
        + R_BE'*(R_SB'*[myobs; zeros(1, size(myobs, 2)) ] + repmat(slocB,1, size(myobs, 2) ) );
   
%     %%% Below is nb particle generation in polar coordinates
%     [bearing_, range_] = cart2pol( myobs(1,:), myobs(2,:) );   
%     range = repmat( range_ , 1, ceil( numpartnewborn/length(myobs(1,:)) ) );
%     bearing = repmat( bearing_ , 1, ceil( numpartnewborn/length(myobs(1,:)) ) );
%     
%     numpars = length( range );
%     
%     ranges = range + randn(1,numpars)*this.stdrange;
%     bearings = bearing + randn(1,numpars)*this.stdang;
%     
%     % The measurements are in the SCS, find them in ECS
%     losS = [ranges.*cos(bearings); ranges.*sin(bearings); zeros(1,numpars )];
%     %%% EO nb particle generation in polar coordinates
    
    % Transform the nb particles to Earth coordinates    
    targsE = repmat(plocE,1,numpars )...
        + R_BE'*(R_SB'*losS + repmat(slocB,1,numpars) );
    
    nbstates_(:,numins+1:numins+ numpars ) = targsE([1,2],:); 
    labels( numins+1:numins+ numpars ) = i;
    numins = numins + numpars;
end

if nargout>1
    varargout{1} = labels;
end
