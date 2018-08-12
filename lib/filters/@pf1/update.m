function varargout = update( this, sensors , varargin )

this.parlhood = 1;

if isempty( this.pred )
   if nargout == 0
        if ~isempty( inputname(1) )
            assignin('caller',inputname(1),this);
        else
            error('Could not overwrite the instance; make sure that the argument is not in an array!');
        end
    else
        varargout{1} = this;
        if nargout>=2
            varargout{2} = this.parlhood;
        end
    end
    return;
end

% Get the particles regarding the loc. dist. of the predicted intensity
w_pred = this.pred.getweights;
p = this.pred.getstates;

numpars = size(p,2);
% Get the likelihood matrices for all measurements
% First, for the first one:
Z1 = this.Z(1);
% Likelihood function matrix
Gk = sensors(1).likelihood( Z1, p );

for mcnt = 2:length(sensors)
    Z_ = this.Z(mcnt);
    
    pt = p;
    if nargin>=3
        pt([1,2],:) = p([1,2],:) - repmat( varargin{1}([1,2], mcnt-1) ,1, numpars );
    end
    Gk = Gk.*sensors(mcnt).likelihood( Z_, pt );

end

this.parlhood = sum( Gk.*w_pred' )/numpars;

if this.parlhood<eps
    wu = ones( numpars,1);
else
    wu = Gk'.*w_pred;
end

persupdate = this.pred;
persupdate = persupdate.sublabels( ones(1, numpars) );

persupdate = persupdate.subweights( wu );

if this.regflag
    persupdate = persupdate.updatekdebwsblabh('nonsparse');
    %persupdate = persupdate.updatekdebwsblab('nonsparse');
    %persupdate = persupdate.updatekdebws('nonsparse');
end
    
% Resample
[persupdate, rind] = persupdate.resample; % Resample with the weights
%persupdate = persupdate.mergeblab;
if this.regflag
    persupdate = persupdate.regwkde(this.regvar);
end
persupdate = persupdate.inchist; % increase the history length by one


this.post = persupdate;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),this);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = this;
    if nargout>=2
        varargout{2} = this.parlhood;
    end
end