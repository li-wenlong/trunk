function i = isin( this, pnts )


if this.type == 0
    pnts = pnts - repmat( this.c,1, size(pnts,2) );
    [th, r] = cart2pol( pnts(1,:), pnts(2,:) );
    i = r<= this.r;    
else
    % use polygon
    i = inpolygon( pnts(1,:), pnts(2,:), this.vertices(1,:), this.vertices(2,:) );
end