function [assocList, varargout ] = genassoc( lab0, lab1, assocwP0, assocwP1 )

assocList = [];
indxs = {};
scores = [];

ulabels0 = unique( lab0,'legacy' );
ulabels1 = unique( lab1,'legacy' );

numP0 = length( lab0 );
numP1 = length( lab1 );

% First, assign the nonzero labels
for i=1:length(ulabels0)
    for j=1:length(ulabels1)
        
        % Try for [ ulabels0(i), ulabels1(j) ]
        
        indx0 = find( lab0 == ulabels0(i) );
        
        % Find the associated pars from the other side
        nonzind = find( assocwP1(indx0) ~=0 );
        assocind = find( assocwP1(indx0(nonzind)) <= numP1 );
        par1ind = assocwP1(indx0(nonzind(assocind)));
    
        % Find the reverse mapping
                
        
        
        % View from the other side
        indx1 = find( lab1 == ulabels1(j) );
        
        % Find the associated pars from the other side
        nonzind = find( assocwP0(indx1) ~=0 );
        assocind = find( assocwP0(indx1(nonzind)) <= numP0 );
        par0ind = assocwP0(indx1(nonzind(assocind)));
        
        prpar0ind = intersect( indx0, par0ind );
        prpar1ind = intersect( indx1, par1ind );
        
        if ~isempty( prpar0ind ) && ~isempty(prpar1ind)
            if ulabels0(i)==0 || ulabels1(j)==0
%                 assocList = [assocList;  [ ulabels0(i), ulabels1(j) ] ];
%                 
%                 indxs = [indxs; {prpar0ind, prpar1ind} ];
%                 scores = [scores;...
%                     [ (length(prpar0ind)+length(prpar1ind))/(numP0 + numP1),...
%                     length(prpar0ind)/numP0,...
%                     length(prpar1ind)/numP1...
%                     ] ];
            else
                assocand =  [ ulabels0(i), ulabels1(j) ];
                % check whether the candidate association is in the list
                inList = 0;
                for k=1:size( assocList, 1 )
                    if ( assocList(k,1) == assocand(1) && ...
                            assocList(k,2) ~= 0 )
                        inList = 1;
                        break;
                    end
                    if ( assocList(k,2) == assocand(2) && ...
                            assocList(k,1) ~= 0 )
                        inList = 1;
                        break;
                    end
                end
                if ~inList
                    assocList = [assocList;  assocand ];
                    indxs = [indxs; {indx0, indx1} ];
                    scores = [scores;[ (length(indx0)+length(indx1))/(numP0 + numP1),...
                        length(indx0)/numP0,...
                        length(indx1)/numP1...
                        ] ];
                end
                
            end
        end
    end
end

% Then, assign zero labelled ones that has not been in any assignment
% First, assign the nonzero labels
for i=1:length(ulabels0)
    for j=1:length(ulabels1)
        if ~( ulabels0(i)==0 || ulabels1(j)==0 )
            continue;
        end
        
        % Try for [ ulabels0(i), ulabels1(j) ]
        
        indx0 = find( lab0 == ulabels0(i) );
        
        % Find the associated pars from the other side
        nonzind = find( assocwP1(indx0) ~=0 );
        assocind = find( assocwP1(indx0(nonzind)) <= numP1 );
        par1ind = assocwP1(indx0(nonzind(assocind)));
        
        % Find the reverse mapping
        
        
        
        % View from the other side
        indx1 = find( lab1 == ulabels1(j) );
        
        % Find the associated pars from the other side
        nonzind = find( assocwP0(indx1) ~=0 );
        assocind = find( assocwP0(indx1(nonzind)) <= numP0 );
        par0ind = assocwP0(indx1(nonzind(assocind)));
        
        prpar0ind = intersect( indx0, par0ind );
        prpar1ind = intersect( indx1, par1ind );
        
        if ~isempty( prpar0ind ) && ~isempty(prpar1ind)
            
            assocand =  [ ulabels0(i), ulabels1(j) ];
            % check whether the candidate association is in the list
            inList = 0;
            for k=1:size( assocList, 1 )
                if ( assocList(k,1) == assocand(1) && assocand(1)~= 0 ) || ...
                        ( assocList(k,2) == assocand(2) && assocand(2)~=0 )
                    inList = 1;
                    break;
                end
            end
            
            if ~inList
                assocList = [assocList;  assocand ];
                indxs = [indxs; {prpar0ind, prpar1ind} ];
                scores = [scores;...
                    [ (length(prpar0ind)+length(prpar1ind))/(numP0 + numP1),...
                    length(prpar0ind)/numP0,...
                    length(prpar1ind)/numP1...
                    ] ];
            end
        end
    end
end

if nargout>=2
    varargout{1} = indxs;
end
if nargout>=3
    varargout{2} = scores;
end



