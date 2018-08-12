function [rows, cols] = findhorizon( this, pstate )
rows = [];
cols = [];

sstate = kstate;
sstate.setstatelabels({'x','y','z','psi','theta','phi'});
sstate.substate([this.location;this.orientation]);
sstate.setvelearth( this.velearth );
        
plocE = pstate.getstate({'x','y','z'});
angBE = pstate.getstate({'psi','theta','phi'});
R_BE = dcm(angBE);

slocB = sstate.getstate({'x','y','z'});
angSB = sstate.getstate({'psi','theta','phi'});
R_SB = dcm( angSB );

for i=1:2
% Sources received in the ECS ; find them in the SCS
    losPsi = angBE(1) + angSB(1);
    if i==1
        horPsi = losPsi - this.horfov/4;
        
        srclocation = [ cos(horPsi)*this.maxrange, sin(horPsi)*this.maxrange,  0]';
    elseif i==2
        horPsi = losPsi + this.horfov/4;
        
        srclocation = [ cos(horPsi)*this.maxrange, sin(horPsi)*this.maxrange,  0]';
    end
    
    losE = srclocation - (pstate.location + R_BE'*sstate.location);
    losS = R_SB*R_BE*losE;

    % Find the Los in polar coordinates
    [th,phi,range] = cart2sph( losS(1), losS(2), losS(3) );
    
    
    bearing = atan2( losS(2), losS(1) );
    elevation = atan2( losS(3), sqrt( losS(1)^2 +  losS(2)^2 ) );
    
    isinfrustum = 0;
    if bearing <= this.horfov/2 && bearing >= -this.horfov/2 
        if elevation <= this.verfov/2 && elevation >= - this.verfov/2
            % The source is inside the fov
            % check if its in the frustrum
            if range<= this.maxrange*1.1 && range >= this.minrange*0.8
               isinfrustum = 1;
            end
        end
    end
    
    if ~isinfrustum
        % Out of range
        continue;
    end
    
    % Find the projection on the image plane using pinhole camera model
    x_im  =  ( -this.F/losS(1) )*losS(2);
    y_im  =  ( -this.F/losS(1) )*losS(3);
    
    if x_im <= this.ipwidth/2 && x_im >= -this.ipwidth/2
        if y_im <= this.ipheight/2 && y_im >= - this.ipheight/2
            % The image point is on the CCD array
            
            % Find the pixel coordinates:
            pix_col  = min( floor( (x_im + this.ipwidth/2  )/(this.pixwidth) ) + 1, this.numcols );
            pix_row  = min( floor( (y_im + this.ipheight/2  )/(this.pixheight) ) + 1, this.numrows );
            
           rows(i) = pix_row;
           cols(i) = pix_col;
            
        end
    end
end