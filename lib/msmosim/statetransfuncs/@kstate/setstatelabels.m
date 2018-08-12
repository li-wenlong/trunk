function varargout = setstatelabels( this, labels )
% This function checks the required state labels and sets that match any
% entry in the object's state
% Murat Uney 
if isa( labels, 'cell' )
    labels = labels(:);
    newlabels = {};
    alabels = kstatelabels;
     
    for j=1:length(labels)
        
        if isa( labels{j},'char')
            % Go on with comparing entries
            ismatch = 0;
            
            c = findincells( alabels.locationlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [ newlabels; labels(j) ];
                continue;
            end
            
            c = findincells( alabels.velocitylabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
            
            c = findincells( alabels.accelerationlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;newstate = [];
            end
                
            c = findincells( alabels.orientationlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
            
            c = findincells( alabels.angularvelocitylabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
             
            c = findincells( alabels.angularmomentlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
            
            c = findincells( alabels.velearthlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
            
            c = findincells( alabels.accelearthlabels, labels(j) );
            if ~isempty(c)
                ismatch = 1;
                newlabels = [newlabels; labels(j) ];
                continue;
            end
            
            warning(sprintf('Unidentified label %s',labels{j} ));
            
        else
            error('Input should be a cell array of strings!');
        end
    end
else
    error('Input should be a cell array');
end
      
if ~isempty( newlabels )
    this.statelabels = newlabels;
    this.catstate;  % Concat the state vector in accordance with the labels
else
    warning('Could not find any matching labels, continuing with default...');
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


            
% function c = findincells( a, b )
% 
% c = [];
% if length(b)==1 & length(a)~=1
%     for j=1:length(a)
%         if strcmp( a{j}, b{1} )
%             c = [c; j ];
%         end
%     end
% elseif length(a) == 1 & length(b) ~=1
%     c = findincells( b,a );
% end
        