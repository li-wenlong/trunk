function xys = getxy( these )

xys = [];
if length(these) >= 2
    xys = these(2:end).getxy;
end

this = these(1);
if ~isempty(this.srbuffer)
    for k=1:length( this.srbuffer )
        % Get the sensor report
        
        srep = this.srbuffer(k);
        
        pstate = srep.pstate;
        sstate = srep.sstate;
        
        plocE = pstate.getstate({'x','y','z'});
        angBE = pstate.getstate({'psi','theta','phi'});
        R_BE = dcm(angBE);
        
        slocB = sstate.getstate({'x','y','z'});
        angSB = sstate.getstate({'psi','theta','phi'});
        R_SB = dcm( angSB );
        
        
        Z = srep.Z;
        
        
        for i=1:length( Z )
            rownum = Z(i).row;
            colnum = Z(i).col;
            
            % Get the unit vectors from the edges of the pixel passing through the origin in sensor coordinate system
            esS = this.pixvector( rownum, colnum );
            
            % Find the centre of mass
            mvec = sum( esS, 2 );
            
            % Convert this vector to Earth Coordinates
            esE = R_BE'*R_SB'*mvec;
            
            % Find the points on the z = 0 plane that intersects with these
            % unit vectors
            
            isonsurface = 1;
            pointsonsurface = [];
            [intersect_point, w] = interwxy( pstate.location + R_BE'*sstate.location, esE );
            if isempty( intersect_point ) || w<0
                isonsurface = 0;
                break;
            end
            if ~isonsurface
                continue;
            end
            xys = [xys, intersect_point([1,2],1)];
            
        end
    end
end

