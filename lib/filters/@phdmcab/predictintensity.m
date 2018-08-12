function varargout = predictintensity( this )


%disp(sprintf('This is predict intensity'));

if ~isempty( this.postintensity ) || ~isempty(this.nbintensity )
    % Have all the particles inhereted from the previous step proceed one step;
    
    % create a phd object
    this.predintensity = phd;
    
    this.predintensity.s.particles = [];
    this.predintensity.s.kdes = [];
    this.predintensity.s.gmm = [];
    
    % Find the scale factor of the intensity
    mu = 0; if ~isempty( this.postintensity ),  mu = mu + this.postintensity.mu; end;
    if ~isempty( this.nbintensity ), mu = mu + this.nbintensity.mu; end;
    
    % The predicted number of targets
    this.predintensity.mu = this.probsurvive*mu;
    
    % Now go on with 
    % Find the particles and weights
    weights_ = [];
    
    % Get the particles representing the prediceted intensity: concatanate the
    % newborn and the posterior particles from the previous step
    if ~isempty( this.nbintensity ) && this.nbintensity.mu ~= 0
        this.predintensity.s.particles = this.nbintensity.s.particles; 
        weights_ = [weights_; this.nbintensity.s.particles.getweights*this.nbintensity.mu]; 
    end
    
    if ~isempty( this.postintensity ) && this.postintensity.mu ~= 0
        this.predintensity.s.particles = ...
            [ this.predintensity.s.particles, this.postintensity.s.particles];
        weights_ = [weights_; this.postintensity.s.particles.getweights*this.postintensity.mu]; 
    end
    
    % Substitute the weights
    this.predintensity.s.particles = this.predintensity.s.particles.subweights( weights_/sum(weights_) );
    
    % Perform the state transition 
    % Dk|k-1(x) = <Dk-1|k-1, \pi(x|.)>
    this.predintensity.s.particles = ...
        this.targetmodel.transtates( this.predintensity.s.particles );
     
    % The particles concatenated in this stage are all persistent particles so tag them as
    % persistent
    this.predintensity.s.particles = this.predintensity.s.particles.allpersistent;
    if ~isempty( this.postintensity )
        this.confintensity = this.postintensity;
        this.confintensity.s.particles = this.targetmodel.transtates( this.postintensity.s.particles );
        
        %this.predintensity.s.particles.getel( ...
        %    [length(weights_)-this.postintensity.s.particles.getnumpoints +1 :length(weights_)] );
        % Don't know why, some times there are a few new born particles in
        % getting in the confintensity in the expression above.
    end
    
    
else
    this.confintensity = phd;
    this.confintensity = this.confintensity([]);
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
