function [nbstates_, varargout] = nbpart( this, obs, numpartnewborn )

Zs = obs.Z;

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

% Find the pixel coordinates of the horizon by sending rays from the max.
% range points in the FOV over the z=0 plane
[horows, hocols] = this.findhorizon(pstate);


nbstates_ = zeros(2,length(Zs)*numpartnewborn );
nbstates_ = nbstates_(:,[]);
labels = zeros(1, length(Zs)*numpartnewborn );
labels = labels([]);

gencount = 0;
for i=1:length(Zs)
    
    % Take the unit vectors from the edges of the pixels
    z = Zs(i);
    
    rnp = 8;
    cnp = 10;
    
    rnm = 12;
    cnm = 10;
    
    [crow, ccol] = condpixel(max(z.row-rnm,1),  max( z.col-cnm,1), horows, hocols );
    
    esS1 = this.pixvector( crow , ccol);
    
    [crow, ccol] = condpixel( min( z.row+rnp, this.numrows ),   max( z.col-cnm,1), horows, hocols );
    
    esS2 = this.pixvector( crow, ccol);
    
    [crow, ccol] = condpixel( min( z.row+rnp, this.numrows ),  min( z.col+cnp,this.numcols) , horows, hocols  );
    
    esS3 = this.pixvector( crow, ccol);
    
    [crow, ccol] = condpixel( max(z.row-rnm,1),  min( z.col+cnp,this.numcols) , horows, hocols );
       
    esS4 = this.pixvector( crow, ccol );
    
    esS = [esS1(:,1), esS2(:,2), esS3(:,3), esS4(:,4) ];
    
    
    % Convert to Earth Coordinates
    esE = R_BE'*R_SB'*esS;
    
    % Find the intersections with the xy plane
    isonsurface = 1;
    pointsonsurface = [];
    for k=1:size( esE , 2 )
        [intersect_point, w] = interwxy( plocE + R_BE'*slocB, esE(:, k) );
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
    gencount = gencount + 1;
    % If all intersect, create particles uniformly distributed in the
    % region with these 4 edges with slice sampling
    min_x = min( pointsonsurface(1,:));
    max_x = max( pointsonsurface(1,:));
    
    min_y = min( pointsonsurface(2,:));
    max_y = max( pointsonsurface(2,:));
    
 
        
    xs = rand( 1, numpartnewborn )*(max_x - min_x ) + min_x ;
    ys = rand( 1, numpartnewborn )*(max_y - min_y ) + min_y ;
    
    nbstates_(:,(gencount-1)*numpartnewborn+1:gencount*numpartnewborn ) = [xs;ys]; 
    labels( (gencount-1)*numpartnewborn+1:gencount*numpartnewborn ) = i;
end

if nargout>1
    varargout{1} = labels;
end
