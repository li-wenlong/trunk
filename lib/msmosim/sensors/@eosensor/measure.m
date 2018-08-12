function varargout = measure(this, varargin )

timestamp = this.time;
pstate = kstate;

for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'time' )
            % Time stamp
            if ~isnumeric( varargin{cnt+1} )
                error('The time stamp should be a scalar.');
            end
            timestamp = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'pstate' )
            pstate =  varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

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

sr = sreport;
sr.time = timestamp;
sr.pstate = pstate;
sr.sstate = sstate;

given = [];
Z = [];
losP = [];
for i=1:length(this.srcbuffer.src)
    % Sources received in the ECS ; find them in the SCS
    losE = this.srcbuffer.src{i}.location - (pstate.location + R_BE'*sstate.location);
    losS = R_SB*R_BE*losE;

    % Find the Los in polar coordinates
    [th,phi,range] = cart2sph( losS(1), losS(2), losS(3) );
    
    if ~this.srcbuffer.src{i}.detwone
        %   % Roll the dice to detect the source
        u = rand; if u>this.pdprofile.getpdprofile(range) ; continue; end;
    end 
   
   
    
    
    bearing = atan2( losS(2), losS(1) );
    elevation = atan2( losS(3), sqrt( losS(1)^2 +  losS(2)^2 ) );
    
    isinfrustum = 0;
    if bearing <= this.horfov/2 && bearing >= -this.horfov/2 
        if elevation <= this.verfov/2 && elevation >= - this.verfov/2
            % The source is inside the fov
            % check if its in the frustrum
            if range<= this.maxrange && range >= this.minrange
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
            
            z  = pixmeas;
            z.row = pix_row;
            z.col = pix_col;
            
            given = [given,this.srcbuffer.src{i}.ID];
            Z = [Z, z];
            losP = [losP, range ]; 
        end
    end
end

% Check the sources that raise detections at the same pixel and discard
% those which are behind another one
if ~isempty( Z )
sel = prunefar( Z.getcat, losP );
Z = Z(:,sel);
if ~isempty( given ) 
given = given( sel );
end
end

 %% Code to add the clutter here
[cout]  = this.clutter.getclutter;
 if ~isempty(cout)
     c = pixmeas;
     
     for j=1:length(cout)
         c.row = floor( cout(j)/this.numcols ) + 1;
         c.col = mod( cout(j) - 1, this.numcols ) + 1 ;
         Z = [Z, c];
         given = [given,0];
     end
 end


sr.given = given;
sr.Z = Z;


this.srcbuffer = {};
this.srbuffer = [this.srbuffer, sr];


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
