function varargout = catstate(this, varargin )

if nargin>=2
    labels = varargin{1};
else
    labels = this.statelabels;
end

alabels = kstatelabels;
newstate = [];
for j=1:length(labels)
        
    % Go on with comparing entries
       
    c = findincells( alabels.locationlabels, labels(j) );
    if ~isempty(c)
        newstate = [ newstate; this.location(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.velocitylabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.velocity(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.accelerationlabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.acceleration(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.orientationlabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.orientation(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.angularvelocitylabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.angularvelocity(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.angularmomentlabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.angularmoment(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.velearthlabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.velearth(c(1)) ];
        continue;
    end
    
    c = findincells( alabels.accelearthlabels, labels(j) );
    if ~isempty(c)
        newstate = [newstate; this.accelearth(c(1)) ];
        continue;
    end   
    warning(sprintf('Unidentified token %s', labels{j}))
end


% 
% 
if nargout == 0
    if nargin == 1 % If called with no label arguments
        this.state = newstate;
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        warning('No ouput variable provided!')
    end
elseif nargout == 1
    varargout{1} = newstate;
end


