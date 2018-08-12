function varargout = onestep(this, sensors)


% Not sure if the check below is neccessary
if ~isa(sensors,'rbsensor1') &&...
         ~isa(sensors,'linobs') &&...
         ~isa(sensors,'rbsensor2') &&...
         ~isa(sensors,'extsensor') && ...
         ~isa(sensors,'extsensor2') && ...
         ~isa(sensors,'rbrrsensor1')
     error('Unidentified sensor type');
end


this = this.predict;

% Save to the buffers
%     this.predintbuffer =  [ this.predintbuffer, { this.predintensity }];
%     this.predcardbuffer = [ this.predcardbuffer, { this.predcard} ];
this.predintbuffer =  [  { this.predintensity }];
this.predcardbuffer = [ { this.predcard} ];

% Get the new born particles; the sum of the weights is needed in the update of persistent particle
this = this.nbpart( sensors );


% Loop over the sensors
Zs = this.Z;
for i=1:length(sensors)
    
    sensor = sensors(i);
    
    if isa(sensor.clutter,'poisclut2' )
        clutcfg = sensor.clutter.cfg;
        clutcfg.lambda = clutcfg.lambda*length(sensors);
        sensor.clutter = poisclut2( clutcfg );
    end
    
    this.Z = Zs(i);
    if i==1
        % update of persistent particles
        this = this.update( sensor );
         if ~isempty( this.postintensity )
            this.mslabels = this.postintensity.s.particles.labels(:);
         else
            this.mslabels = [];
         end
    else
        predint = this.predintensity;
        predcard = this.predcard;   
        
        postint = this.postintensity;
        postcard = this.postcard;
        
         if ~isempty( this.postintensity )
            this.predintensity = this.postintensity;
            this.predcard = this.postcard;
         end
         
         [this] = this.update( sensor );
          % If after the update, the posterior is empty, hold the previous one
        
        if isempty(this.postintensity)
            this.postintensity = postint;
            this.postcard = postcard;
        else
            this.mslabels = [this.mslabels(this.resindx,:), this.postintensity.s.particles.labels(:)]; 
        end
        
        this.predintensity = predint;
        this.predcard = predcard; 
    end
end
 this.Z = Zs;       
         
        




% Save to the buffers
%     this.postintbuffer = [ this.postintbuffer, { this.postintensity} ];

this.postintbuffer = [  { this.postintensity} ];
this.postcardbuffer = [ this.postcardbuffer, { this.postcard } ];

% Hacking now:
% Below, we gotta find the number of persistent clusters
%intensity1 = par2int( this.getperspostintensity );
%if ~isempty( intensity1 )
%numperstarg = length( intensity1.s.gmm.w );
%else
%    numperstarg = 0;
%end

% thisbuffer.postcardpers = zeros(size(thisbuffer.postcard));
% thisbuffer.postcardpers( numperstarg + 1 ) = 1;
    
% this.postcardbuffer = [this.postcardbuffer, thisbuffer];

    

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end