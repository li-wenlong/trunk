function src = getsources(this)

s = this.getkstate;

xpe = s.location; % Platform location in ECS
angBE = s.orientation; % Platform orientation from ECS
vE = s.velearth; % Platform velocity in ECS

R_be = dcm( angBE );

src = {};
for i=1:length( this.sources )
    src_ = this.sources{i};
    
    xsb = src_.location;
    angSB = src_.orientation; % This is the source orientation wrt Body
    
    % Find the location in earth fixed
    
    xse = xpe + R_be'*xsb; % Source location in ECS
    
    R_sb = dcm( angSB );
    angSE = idcm( R_sb*R_be ); % Source orientation wrt ECS
    
    src_.location = xse;
    src_.orientation = angSE;
    src_.velearth = vE; % Earth velocity of the source is same with the body
    src_.velocity = vE; % 
    src_.detwone = 0;
    
    if length( this.track.treps ) == 1; src_.detwone = 1;end;% force detection at birth
    
    src{i} =  src_;
end
    
