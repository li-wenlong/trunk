function varargout = nbpart( this, sensor )

isquit = 0;
if ~isempty( this.post )
   % quit 
    isquit = 1;
end
if isquit
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end

% Check whether there are at least one sensor measurement to create
% particles around.
senlist = zeros(1,length(sensor));
for i=1:length(this.Z)
    if length( this.Z(i).Z ) ~=0
        senlist(i) = 1;
        isquit = 0;
    end
end

if isa( this.Z(1).Z,'mlinmeas' )
    if length(this.Z(1).Z)==1
        if isempty(this.Z(1).Z.Z)
            isquit = 1;
        end
    end
end
        
if isquit
    this.post = [];
    if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
    end
    return;
end



i = 1;
% Generate the position components of the state vectors:
if isa( sensor, 'rbrrsensor1')
    % If range bearing range rate sensor
    [states, labels] = sensor.nbpart( this.Z(i), this.numpart, this.veldist  );
    locstates = states([1,2],:);
elseif isa( sensor, 'bearingsensor1') || isa( sensor, 'rbsensor2')
    [locstates, labels] = sensor.nbpart( this.Z(i), this.numpart );    
else
    [locstates, labels] = sensor.nbpart( this.Z(i), this.numpart );
end


numpart = length(labels);
% Get unique labels per each different entry in labels
[ulabels, this.lgen] = this.lgen.getlabels( 'labelmap', labels );

locparticles = particles( 'states', locstates, 'labels', ulabels ); % create equal weighted particles
% locparticles.allnb; % All particles are by default created new born
locparticles = locparticles.subblabels(  ulabels );

if this.regflag
    locparticles.kdebws('nonsparse'); % Here, the BWs are found
end

% numlabels = unique( labels )

isgen = 0;
% Generate the velocity components of the state vectors:
if isa( sensor, 'rbrrsensor1') && ~isgen
    
    % Get the already generated velocity components
    vels = states([3,4],:);
    comps = labels;
    % [vels, comps] = gensamples(this.veldist, numpart );
    velparticles = particles('states', vels, 'labels', comps(:) );
    [ulabels, this.lgen] = this.lgen.getlabels( 'labelmap', comps );
    velparticles.subblabels( ulabels );
    if this.regflag
        velparticles.kdebws('nonsparse'); % Here, the BWs are found
    end
    nbparticles = [locparticles; velparticles];
    isgen = 1;
else
    isgen = 0;
end

if ~isempty( findincells( fieldnames(this), {'veldist'} ) ) && ~isgen
    if ~isempty(this.veldist)
        [vels, comps] = gensamples(this.veldist, numpart );
        velparticles = particles('states', vels, 'labels', comps(:) );
        [ulabels, this.lgen] = this.lgen.getlabels( 'labelmap', comps );
        velparticles.subblabels( ulabels );
        if this.regflag
            velparticles.kdebws('nonsparse'); % Here, the BWs are found
        end
        nbparticles = [locparticles; velparticles];
        isgen = 1;
    end
end

if ~isgen
    error('No velocity prior is defined!');
end
nbparticles_ = nbparticles;

% birth intensity
nbparticles_.eqweights;

this.post = nbparticles_;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
