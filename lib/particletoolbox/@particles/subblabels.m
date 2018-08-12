function varargout = subblabels( inpars, blabels, varargin )

if ~isnumeric(blabels)
    error('The labels can only be numerical values!')
end

N = size(blabels, 1);
M = size(blabels, 2 );

[D, NP] = size( inpars.states );

if isempty( inpars.blmap )
    % Assign it for the first time
    if N==1
        blmap = ones(D,1);
    else
        blmap = [1:N]';
    end
else
    blmap = inpars.blmap;
end

nvarargin = length(varargin);
argnum = 1;
blmap_ = [];
while argnum<=nvarargin
    if isa( lower(varargin{argnum}), 'char')
        switch lower(varargin{argnum})
            case {'blmap'}
                if argnum + 1 <= nvarargin
                    blmap_ = varargin{argnum+1}; % This is a cell array
                    argnum = argnum + 1;
                end
            case {''}
               
                
            otherwise
                error('Wrong input string');
        end
    end
     argnum = argnum + 1;
end
if ~isempty(blmap_)
    % blmap_ is entered
    if length(blmap_ ) ~= size( blabels, 1)
        error('The birth labels array does not match the birth label map of states!');
    end
end

% convert the map contained in the cell array to a function of state
% entries, and find the rows of the .blabels entry to be replaced if there
% are any.
numrows = size( inpars.blabels, 1 );
if ~isempty( blmap_ )
for i=1:length( blmap_ )
    blmap__ = blmap_{i};
    blmap( blmap__ ) = numrows + i;
end

if length( blmap ) ~= D
    error('Birth label map of states does not match the state dimensions!');
end
else
    blmap = blmap + numrows;
end

% Check the length maybe ???
if size(blabels,2)==1
    inpars.blabels = [inpars.blabels;repmat(blabels,1, Np )];
else
    inpars.blabels = [inpars.blabels; blabels];
end
% Remove unused rows,
redrows = []; % redundant rows
for i=1:D
    ind = find( blmap == i );
    if isempty( ind )
        % Then, row i of blabels is redundant
        redrows = [redrows, i];
    end
end
% redrow is in order
for i=1:length(redrows)
    inpars.blabels = [ inpars.blabels(1:redrows(i)-1,:);inpars.blabels(redrows(i)+1:end,:)];
    
    ind = find(blmap>redrows(i));
    blmap(ind) = blmap(ind)-1;
    
    ind = find( redrows > redrows(i) );
    redrows(ind) = redrows(ind) - 1;
end

inpars.blmap = blmap;

if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1), inpars);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = inpars;
end
  
