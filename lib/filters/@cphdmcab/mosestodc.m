function [Xh, varargout] = mosestodc( this, varargin )
% MOSESTODC is the method for Multi-object state estimate based on observation driven clustering.


Xh = [];
Cs = {};
indxs = {};
clmass = [];

if isempty(this.postintensity)
    if nargout >= 2
        varargout{1} = Cs;
    end
    if nargout >= 3
        varargout{2} = indxs;
    end
    if nargout >= 4
        varargout{3} = clmass;
    end

    return;
end


[maxcards, meancards  ]= this.estnumtarg;
numtargest = round( meancards(end) );
threshold = 1/numtargest/2;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'numtargets'}
                if argnum + 1 <= nvarargin
                    numtargest = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'threshold'}
                if argnum + 1 <= nvarargin
                    threshold = varargin{argnum+1}(1);
                    argnum = argnum + 1;
                end
            case {''}
                legendOn = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end
if ~isempty( this.mslabels )
   % Here, find the labels using the labels assigned by different multi-sensor updates and 
   % store in the @particles object
   [numpar, N] = size( this.mslabels );
   if N>=2
   for cnt=1:N
       inds = find( this.mslabels(:,cnt)~=0 );
       lgen = this.lgen;
       nlabs = lgen.getlabels('labelmap', this.mslabels(inds,cnt) );
       this.lgen = lgen;
       this.mslabels( inds, cnt ) = nlabs;
   end
   plabels = findlabels( this.mslabels );
   this.postintensity.s.particles = this.postintensity.s.particles.sublabels( plabels ); 
   end
end

[Xh, Cs, indxs, clmass ] = this.postintensity.mosestodc('numtargets', numtargest, 'threshold', threshold);

if ~isempty( this.mslabels )
   [numpar, N] = size( this.mslabels );
   if N>=2
       %  Prune those clusters exceeding the estimated number of targets
       [sclmass, sindx] = sort( clmass, 'descend');
       incindx =  sindx(1:min( numtargest, length(sindx) ) ) ;
       Xh = Xh(:, incindx);
        Cs = Cs(incindx);
        indxs = indxs(incindx);
        clmass = clmass(incindx);
       
   end
end

if nargout >= 2
    varargout{1} = Cs;
end
if nargout >= 3
    varargout{2} = indxs;    
end
if nargout >= 4
    varargout{3} = clmass;
end
end
function plab = findlabels( mslabels )

[numpar, N] = size( mslabels );

if N==1
    plab = mslabels;
    return;
end

[assocList, indxs, scores] = genassoc( mslabels(:,1), mslabels(:,2), [1:numpar]', [1:numpar]' );
plab = mslabels(:,2);
for cnt = 1:size( assocList, 1 )
    if assocList(cnt,2) ~= 0
        nonzlab = assocList(cnt,2);
    else
        nonzlab = assocList(cnt,1);
    end
    
    plab( indxs{cnt,1} ) = nonzlab;
    plab( indxs{cnt,2} ) = nonzlab;  
end


plab = findlabels( [ plab , mslabels(:,3:N)] );

end % EO findlabels()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [assocList, varargout ] = genassoc( lab0, lab1, assocwP0, assocwP1 )

assocList = [];
indxs = {};
scores = [];

ulabels0 = unique( lab0 );
ulabels1 = unique( lab1 );

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
end