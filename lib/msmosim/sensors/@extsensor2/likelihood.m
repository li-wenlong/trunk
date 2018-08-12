function G = likelihood( this, obs, particles )


%% Hacking this time
Zs = obs.Z; % Zs are mlinmeas objects

if isa( particles , 'particle' )
    numParticles = length(particles);
elseif isa( particles, 'particles' )
    numParticles = particles.numparticles;
elseif isa( particles, 'numeric' )
    numParticles = size( particles, 2 );
end

G = zeros( length(Zs), numParticles );

if numParticles == 0
    return;
end

if isa( particles , 'particle' )
    state_ = particles.catstates;
elseif isa( particles, 'particles' )
    state_ = particles.getstates;
elseif isa( particles, 'numeric')
    state_ = particles;
end

locationE_ = [state_([1,2],:); zeros(1, size(state_,2) ) ];
velocityE_ = [state_([3,4],:); zeros(1, size(state_,2) ) ];
% No observation on the velocity component
% velocityE_ = [ state_([3,4],:); zeros(1,numParticles) ];

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
 
info.P = this.P;
info.x_min = this.x_min;
info.x_max = this.x_max;
info.y_min = this.y_min;
info.y_max = this.y_max;
info.lambda = this.lambda;
info.gamma = this.gamma;
info.angle = this.angle;
info.major_axis = this.major_axis;
info.minor_axis = this.minor_axis;
info.r_sig1 = this.r_sig1;

 % Sources received in the ECS ; find them in the SCS
losE = locationE_ - repmat( (pstate.location + R_BE'*sstate.location),1, numParticles );
losS = R_SB*R_BE*losE;

velE = velocityE_ - repmat( ( pvelE + R_BE'*svelB ),1, numParticles );
velS = R_SB*R_BE*velE;

stateS = [losS([1,2],:); velS([1,2],:)];

[angs, rads] = cart2pol( losS(1,:), losS(2,:));
angs =mapang(angs);

for i=1:length(Zs)
    lhoods = zeros(1, size(stateS, 2) );
    myobs = Zs(i).Z;
    if isempty(myobs)
        G(i,:) = lhoods;
        continue;
    end
        
        
  %  myobs = decobs(myobs, min( ceil( info.gamma/2), 10 ) ); % Decimate obs.
    
    
    zc = mat2cell( myobs, size(myobs,1),ones(1,size(myobs,2))  );
    % Find those particles which will have zero likelihood because there
    % can not be a target closer to the lidar in an angle bin, then the
    % lidar measurement itself.
    
    % Find the obs in polar coordinates
    [obsangs, obsrads ] = cart2pol( myobs(1,:), myobs(2,:) );
    obsangs = mapang(obsangs);
    
    % north bound passing through the origin
    maxang = max(obsangs);
    minang = min(obsangs);
    
    candindless = find( angs<= maxang );
    candindmore = find( angs>=minang );
    candindpol = intersect( candindless, candindmore );
    
        
    % Find the closest observation
    [minval, minind] = min( sqrt( sum( myobs.*myobs ,1) ) );
        
    % The line will be vertical (in the sensor coordinate system)
    % which scans from -pi to pi (i.e., targets in quadrants IV and I)
    candindx = find( losS(1,:)>= myobs( 1, minind ) ); % indices of candidates for having nonzero likelihood
    
    % Find the intersection of the RHS points within the polar range
    candind = intersect( candindpol, candindx );
    
   
    if ~isempty( candind )
    xc = stateS(:, candind );
    
    
    
    % Here, call the multObjLikelihood
   % disp( sprintf('# of states: %d, # of obs: %d', size(xc, 2), size(myobs,2) ) )
   % tic    
    L = multipoissonlhood(info, myobs, xc, repmat(this.major_axis,1,size(xc,2) ), repmat(this.minor_axis,1,size(xc,2) ),...
        repmat(0,1,size(xc,2) ), repmat(this.r_sig1*3,1,size(xc,2) ), repmat(this.r_sig1,1,size(xc,2) ) );
   % toc

    lhoods( candind ) = L;
    end
    
    G(i,:) = lhoods;
%     
%     % Uncomment below to display
%     if ~exist('myfighandle')
%         myfighandle = figure;
%         
%         plotset(stateS)
%     end
%     ind = find( G(i,:) > 50 );
%     hold on
%     plot3( stateS(1,ind), stateS(2,ind)  , G(i,ind), 'r.')
%     plotset( myobs,'options','''Color'',[0 0 0],''Marker'',''x''','axis',gca)
    
    
   

end

if ~isempty(find(isnan(G)==1))
    error('NaNs in the likelihood matrix!');
end

