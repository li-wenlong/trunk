function varargout = predictintensity( this, sensorobj )


%disp(sprintf('This is predict intensity'));

% Remove the line below; it is used to inject a particle for testing
% this.postintensity = particle( 'state',[1 2 3 4],'weight',0.5, 'label', 'nb');

% Have all the particles one step;
if ~isempty( this.postintensity ) || ~isempty(this.nbintensity )
    this.predintensity = phd;
    
    this.predintensity.s.particles = [];
    this.predintensity.s.kdes = [];
    this.predintensity.s.gmm = [];
    
       
    % Find the scale factors of the mixture
    sc1 = 0; 
    if ~isempty( this.postintensity )
        sc1 = this.postcard(2)*this.probsurvive/this.predcard(2); 
    end
    sc2 =  this.nbintensity.mu*(1-this.postcard(2))/this.predcard(2);
    
    % Save the intensity
    this.predintensity.mu = this.predcard(2);
    
    % Now go on with
    % Find the particles and weights
    weights_ = [];
    
    % Get the particles representing the prediceted intensity: concatanate the
    % newborn and the posterior particles from the previous step
    if ~isempty( this.nbintensity ) && this.nbintensity.mu ~= 0
        this.predintensity.s.particles = this.nbintensity.s.particles;
        weights_ = [weights_; this.nbintensity.s.particles.getweights*sc2];
    end
    
    if ~isempty( this.postintensity ) && this.postintensity.mu ~= 0
         % Perform the state transition 
         % Dk|k-1(x) = <Dk-1|k-1, \pi(x|.)>
         tranparticles = this.targetmodel.transtates( this.postintensity.s.particles );
         [dummy, labels] = assoc2pix( sensorobj, tranparticles, this.Z.pstate, this.Z.sstate );
         % Find the corresponding pixels to label these particles
         tranparticles.sublabels( labels );
    
        this.predintensity.s.particles = ...
            [ this.predintensity.s.particles, tranparticles];
        tranweights = this.postintensity.s.particles.getweights;
        weights_ = [weights_; (tranweights/sum(tranweights))*sc1]; 
    end
    
     this.predintensity.s.particles = this.predintensity.s.particles.subweights( weights_/sum(weights_) );
    % make all persistent
    this.predintensity.s.particles = this.predintensity.s.particles.allpersistent;
    
    % store the markov shifted intensity
    if ~isempty( this.postintensity )
        this.confintensity = this.postintensity;
        this.confintensity.s.particles = tranparticles;
        
        %this.predintensity.s.particles.getel( ...
        %    [length(weights_)-this.postintensity.s.particles.getnumpoints +1 :length(weights_)] );
        % Don't know why, some times there are a few new born particles in
        % getting in the confintensity in the expression above.
    end
      
end


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
