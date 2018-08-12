function [pixrow, pixcol] = condpixel(pixrow, pixcol, horows, hocols )
% Finds whether the pixel is below the horizon and if it is,
% Returns the coordinates of the pixel that is below the horizon

horrow1 = horows(1); horcol1 = hocols(1); 
horrow2 = horows(2); horcol2 = hocols(2);

yy_new = pixrow;
xx_new = pixcol;

if ( yy_new - horrow1 )/(horrow1 - horrow2)<= (xx_new-horcol1)/(horcol1-horcol2)
    % Above the horizon
    yy_new = ceil( (xx_new-horcol1)*(horrow1 - horrow2)/(horcol1-horcol2) + horrow1 ) + 1;
end

pixrow = yy_new;
pixcol = xx_new;