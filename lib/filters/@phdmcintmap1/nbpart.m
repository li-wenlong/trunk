function varargout = nbpart( this, sensors, varargin )

isquit = 1;

% Check whether there are at least one sensor measurement to create
% particles around.
senlist = zeros(1,length(sensors));
for i=1:length(this.Z)
    if length( this.Z(i).Z ) ~=0
        senlist(i) = 1;
        isquit = 0;
    end
end

if isquit
    this.nbintensity = [];
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

if nargin>=3
    regs = varargin{1};
end

for i = 1:length(sensors)
    sensor = sensors(i);
    
    [locstates, labels] = sensor.nbpart( this.Z(i), this.numpartnewborn );
    locstates = locstates([1,2],:);
    if i>=2
        locstates = locstates + repmat( regs([1,2],i-1), 1, size(locstates,2) );
    end
    
    numpartnewborn = length(labels);
    %% Get unique labels per each different entry in labels
    %[ulabels, this.lgen] = this.lgen.getlabels( 'labelmap', labels );
    % commenting out the above lines for now, and using the labels from the
    % sensor's generator
    ulabels = labels;
    
    locparticles = particles( 'states', locstates, 'labels', ulabels ); % create equal weighted particles
    % locparticles.allnb; % All particles are by default created new born
    locparticles = locparticles.subblabels(  ulabels );
    
    if this.regflag
        locparticles.kdebws('nonsparse'); % Here, the BWs are found
    end
    
    % numlabels = unique( labels )
    
    isgen = 0;
    
    if ~isempty( findincells( fieldnames(this), {'veldist'} ) ) && ~isgen
        if ~isempty(this.veldist)
            [vels, comps] = gensamples(this.veldist, numpartnewborn );
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
        if isa( this.speedminmax, 'cell' )
            vels = sqrtm(this.speedminmax{2})*randn(2,numpartnewborn) + repmat(this.speedminmax{1} ,1,numpartnewborn );
            nbstates = [locstates; vels];
            isgen = 1;
        else
            bearings = rand(1, numpartnewborn)*2*pi;
            speeds = rand(1,  numpartnewborn )*abs(this.speedminmax(2)-this.speedminmax(1) ) + ( this.speedminmax(1) );
            nbstates = [locstates; speeds.*cos(bearings); speeds.*sin(bearings)];
            isgen = 1;
        end
        nbparticles = particles( 'states', nbstates, 'labels', ulabels );
    end
    
    if ~isgen
        error('No velocity prior is defined!');
    end
    if i==1
        nbparticles_ = nbparticles;
    else
        nbparticles_ = [nbparticles_, nbparticles];
    end
end
% birth intensity
nbparticles_.eqweights;
% Hacking now
this.nbintensity = phd;
this.nbintensity.mu = this.probbirth;
this.nbintensity.s.particles = nbparticles_;
this.nbintensity.s.kdes = [];
this.nbintensity.s.gmm = [];


%nbparticles = nbparticles.subweights( this.probbirth/length(nbparticles)*ones(1, length( nbparticles ) )  );
%nbparticles = nbparticles.sublabels({'nb'});

%this.postintensity = nbparticles;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
end
