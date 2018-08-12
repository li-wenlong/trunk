function [G, varargout] = likelihood( this, obs, particles )


%% Hacking this time
Zs = obs.Z;
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

locationE_ = [ state_([1,2],:); zeros(1,numParticles) ];

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
    
    losE = locationE_ - repmat( (pstate.location + R_BE'*sstate.location),1, numParticles );
    losS = R_SB*R_BE*losE;
else
    % The incoming particles locationE_ are already in sensor coordinate
    % system
    plocE = [0 0 0]';
    angBE = [0 0 0]';
    R_BE = eye(3);
    
    slocB = [0 0 0]';
    angSB = [0 0 0]';
    R_SB = eye(3);
    
    losE = locationE_;
    losS = losE;  
end


[th,ran,alt] = cart2pol( losS(1,:), losS(2,:), losS(3,:) ); % bearing range altitude
ranges = sqrt( sum( losS.*losS,1 ) );
bearings = atan2( losS(2,:), losS(1,:) );
M = ones( length(bearings), 1);
% 
% % Now check the mask
% % 1) w.r.t. \alpha
% ind = find( bearings > this.alpha ); 
% M(ind) = 0;
% % if ~isempty(ind)
% %     disp(sprintf('>alpha'));
% % end
% 
% ind = find( bearings < -this.alpha );
% M(ind) = 0;
% % if ~isempty(ind)
% %     disp(sprintf('<alpha'));
% % end

[X,Y] = meshgrid( [-10:5], [-15:15] );
neighbours = [X;Y]';

% neighbours = [[0 1];[0 -1];[1 0];[-1 0];[1 1];[1 -1];[-1 1];[-1 -1];...
%     [0 2];[0 -2];[2 0];[-2 0];[2 2];[2 -2];[-2 2];[-2 -2];...
%     [0 3];[0 -3];[3 0];[-3 0];[3 3];[3 -3];[-3 3];[-3 -3];...
%     [0 4];[0 -4];[4 0];[-4 0];[4 4];[4 -4];[-4 4];[-4 -4];...
%     [0 5];[0 -5];[5 0];[-5 0];[5 5];[5 -5];[-5 5];[-5 -5];...
%     [0 6];[0 -6];[6 0];[-6 0];[6 6];[6 -6];[-6 6];[-6 -6];...
%     [0 7];[0 -7];[7 0];[-7 0];[7 7];[7 -7];[-7 7];[-7 -7];...
%     ];


for i=1:length(Zs)
    
    % Get the unit vectors from the edges of the pixel passing through the origin in sensor coordinate system
    esS = this.pixvector( Zs(i).row, Zs(i).col );
    
    % Convert these vectors to Earth Coordinates
    esE = R_BE'*R_SB'*esS;
    
    % Find the points on the z = 0 plane that intersects with these
    % unit vectors
    
    isonsurface = 1;
    pointsonsurface = [];
    for k=1:size( esE , 2 )
        [intersect_point, w] = interwxy( pstate.location + R_BE'*sstate.location, esE(:, k) );
        if isempty( intersect_point ) || w<0
            isonsurface = 0;
            break;
        end
        if w<0
            warning('The unit vector is not headed towards the xy plane!')
        end
        pointsonsurface = [pointsonsurface, intersect_point];
    end
    
    if ~isonsurface
        continue;
    end
    
    % Find those particles in the polygon specified by pointsonsurface
    G(i,:) = ...
        (1/(size(neighbours,1 )+1))*inpolygon( locationE_(1,:)' , locationE_(2,:)', pointsonsurface(1,:)' , pointsonsurface(2,:)' )';
    
    % Repeat this for 8-neigbors
    for ncnt = 1:size( neighbours ,1)
        rownum =  max( min( Zs(i).row + neighbours(ncnt, 1), this.numrows ),1);
        colnum =  max( min( Zs(i).col + neighbours(ncnt, 2), this.numcols), 1);
        
        esS = this.pixvector( rownum, colnum );
        
        % Convert these vectors to Earth Coordinates
        esE = R_BE'*R_SB'*esS;
        
        % Find the points on the z = 0 plane that intersects with these
        % unit vectors
        
        isonsurface = 1;
        pointsonsurface = [];
        for k=1:size( esE , 2 )
            [intersect_point, w] = interwxy( pstate.location + R_BE'*sstate.location, esE(:, k) );
            if isempty( intersect_point ) || w<0
                isonsurface = 0;
                break;
            end
            if w<0
                warning('The unit vector is not headed towards the xy plane!')
            end
            pointsonsurface = [pointsonsurface, intersect_point];
        end
        
        if ~isonsurface
            continue;
        end
        
        % Find those particles in the polygon specified by pointsonsurface
        G(i,:) = G(i,:) + ...
            (1/(size(neighbours,1)+1) )*inpolygon( locationE_(1,:)' , locationE_(2,:)', pointsonsurface(1,:)' , pointsonsurface(2,:)' )';
      
    end
    
    
    
end


if nargout >=2
    varargout{1} = M;
end

if nargout>=3
    varargout{2} = [bearings;ran];
end

