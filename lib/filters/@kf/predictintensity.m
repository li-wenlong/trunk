function varargout = predictintensity( this )


%disp(sprintf('This is predict intensity'));

% Remove the line below; it is used to inject a particle for testing
% this.postintensity = particle( 'state',[1 2 3 4],'weight',0.5, 'label', 'nb');

% Have all the particles one step;
if ~isempty( this.postintensity ) || ~isempty(this.nbintensity )
    this.predintensity = phd;
    
    this.predintensity.s.particles = [];
    this.predintensity.s.kdes = [];
    this.predintensity.s.gmm = [];
    
       
    % Find the scale factor of the intensity
    mu = 0; 
    if ~isempty( this.postintensity )
        mu = mu + this.postintensity.mu*this.probsurvive*this.postcard(2)/this.predcard(2); 
    end
    if ~isempty( this.nbintensity ), mu = mu + this.nbintensity.mu; end;
    
    % Save the intensity
    this.predintensity.mu = mu;
    
    % Find the particles and weights
    weights_ = [];
    if ~isempty( this.nbintensity )
        this.predintensity.s.particles = this.nbintensity.s.particles; 
        weights_ = [weights_; this.nbintensity.s.particles.getweights*this.nbintensity.mu]; 
    end
    
    if ~isempty( this.postintensity )
        this.predintensity.s.particles = ...
            [ this.predintensity.s.particles, this.postintensity.s.particles];
        weights_ = [weights_; this.postintensity.s.particles.getweights*this.postintensity.mu]; 
    end
    
     this.predintensity.s.particles = this.predintensity.s.particles.subweights( weights_/sum(weights_) );
    
    % Perform the state transition 
    this.predintensity.s.particles = ...
        this.targetmodel.transtates( this.predintensity.s.particles );
     
    
    % make all persistent
    this.predintensity.s.particles = this.predintensity.s.particles.allpersistent;
    
      
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
