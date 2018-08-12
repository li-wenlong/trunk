function xy = getxy(these)

if isempty( these(1).Z(1) )
    xy = zeros(2,0);
    return;
end

if length( these ) > 1
    xy = [ getxy( these(1) ),getxy( these(2:end) ) ];
    return;
else
    this = these;
end

if isa( this.Z(1), 'rbmeasext' ) || isa( this.Z(1), 'rbmeas' )
    numreps = length( this.Z );
    xy = zeros( 2, numreps );
    pstate = this.pstate;
    sstate = this.sstate;
    
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );%
    
    rbarr = this.Z.getcat;
    
    if size(rbarr,1) == 2
        bearings = rbarr(2,:);
        ranges = rbarr(1,:);
    else
        bearings = rbarr(4,:);
        ranges = rbarr(3,:);
    end
    
    
    xs = ranges.*cos(bearings);
    ys = ranges.*sin(bearings);
    zs = zeros( size(xs) );
    
    numpts = length( xs );
    losS = [xs;ys;zs];
    
    losE =  R_BE'*( R_SB'*losS + repmat( slocB, 1, numpts ) ) + repmat( plocE, 1, numpts);
    
    xy = losE([1,2],:);
    
elseif isa( this.Z(1), 'linmeas' )
    numreps = length( this.Z );
    xy = zeros( 2, numreps );
    pstate = this.pstate;
    sstate = this.sstate;
    
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );
    
    xy_SCS = this.Z.getcat;
    
    xs = xy_SCS(1,:);
    ys = xy_SCS(2,:);
    zs = zeros( 1, length(xs) );
    
    numpts = length( xs );
    losS = [xs;ys;zs];
    
    losE =  R_BE'*( R_SB'*losS + repmat( slocB, 1, numpts ) ) + repmat( plocE, 1, numpts);
    
    xy = losE([1,2],:); 
    
elseif isa( this.Z(1), 'rbmeassap' )
     numreps = length( this.Z );
    xy = zeros( 2, numreps );
    pstate = this.pstate;
    sstate = this.sstate;
    
    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);
    
    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );%
    
    rbarr = this.Z.getcat;
    
   
    bearings = rbarr(2,:);
    ranges = rbarr(1,:);
    
    
    xs = ranges.*cos(bearings);
    ys = ranges.*sin(bearings);
    zs = zeros( size(xs) );
    
    numpts = length( xs );
    losS = [xs;ys;zs];
    
    losE =  R_BE'*( R_SB'*losS + repmat( slocB, 1, numpts ) ) + repmat( plocE, 1, numpts);
    
    xy = losE([1,2],:);
    
    
end
