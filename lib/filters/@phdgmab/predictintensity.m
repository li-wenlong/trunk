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
    % Find the components and weights
    weights_ = [];
    gks = [];
    
    % Get the particles representing the prediceted intensity: concatanate the
    % newborn and the posterior particles from the previous step
    if ~isempty( this.nbintensity ) && this.nbintensity.mu ~= 0
        gks = [gks; this.nbintensity.s.gmm.pdfs]; 
        weights_ = [weights_; this.nbintensity.s.gmm.w*this.nbintensity.mu]; 
    end
    
    if ~isempty( this.postintensity ) && this.postintensity.mu ~= 0
        gks = [ gks; this.postintensity.s.gmm.pdfs];
        weights_ = [weights_; this.postintensity.s.gmm.w*this.postintensity.mu]; 
    end
    
      % Perform the state transition 
    % Dk|k-1(x) = <Dk-1|k-1, \pi(x|.)>
    transgks = this.targetmodel.transtates( gks );
    
    this.predintensity.s.gmm = gmm( weights_, transgks );  
    
     if ~isempty( this.postintensity ) && this.postintensity.mu ~= 0
        this.confintensity = this.postintensity;
        this.confintensity.s.gmm.pdfs = this.targetmodel.transtates( this.postintensity.s.gmm.pdfs );
        
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
