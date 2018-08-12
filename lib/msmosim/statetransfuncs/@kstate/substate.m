function varargout = substate(this, instate, varargin )
% Substitute into state

if ~isa( instate, 'numeric' )
    error('The state should be of type numeric!');
end
instate = instate(:);
% Check if the labels are provided
if nargin>=3
    labels = varargin{1};
    if isa( labels, 'cell' )
        for i=1:length( labels )
           if ~ischar( labels{i}  )
              error('The cell array should contain strings for the labels!') ;
           end
        end
    else
        error('The second input should be a cell array of strings corresponding to labels!');
    end
else
    if length( instate )~=length( this.statelabels )
        error( sprintf( 'The state should of size %dx1 rather than %dx1...', ...
            length( this.statelabels ),...
            length( instate ) ));
    end
    labels = this.statelabels;
end
alabels = kstatelabels;
for j=1:length(labels)
        

    c = findincells( alabels.locationlabels, labels(j) );
    if ~isempty(c)
        % this.state( j ) = instate( j );
        this.location( c ) = instate( j );
        continue;
    end
    
    c = findincells( alabels.velocitylabels, labels(j) );
    if ~isempty(c)
%        this.state( j ) = instate( j );
%        this.velocity(c) = instate( j );
        this.setvelocity( labels{j}, instate(j) ); % Call the 
        continue;
    end
    
    c = findincells( alabels.accelerationlabels, labels(j) );
    if ~isempty(c)
    %    this.state( j ) = instate( j );
    %    this.acceleration(c)  = instate( j );
    this.setacceleration( labels{j}, instate(j) );
        continue;
    end
    
    c = findincells( alabels.orientationlabels, labels(j) );
    if ~isempty(c)
        this.state( j ) = instate( j );
        this.orientation(c) = instate( j );
        continue;
    end
    
    c = findincells( alabels.angularvelocitylabels, labels(j) );
    if ~isempty(c)
        this.state( j ) = instate( j );
        this.angularvelocity(c)  = instate( j );
        continue;
    end
    
    c = findincells( alabels.angularmomentlabels, labels(j) );
    if ~isempty(c)
        this.state( j ) = instate( j );
      %  this.angularmoment( c ) = instate( j );
      this.setangularmoment( labels{j},  instate( j ) );
        continue;
    end
    
    c = findincells( alabels.velearthlabels, labels(j) );
    if ~isempty(c)
       % this.state( j ) = instate( j );
       % this.velearth( c ) = instate( j );
       this.setvelearth( labels{j}, instate(j) );
        continue;
    end
    
    c = findincells( alabels.accelearthlabels, labels(j) );
    if ~isempty(c)
       % this.state( j ) = instate( j );
       % this.accelearth( c ) = instate( j );
       this.setaccelearth( labels{j}, instate(j) );
        continue;
    end
    warning(sprintf('Unidentified label %s', labels{j}));
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


  
        
