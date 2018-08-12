function [pgks] = mergegks( gks, varargin )

threshold = 1.e-6;
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'threshold' )
            threshold = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

% First, separate the scalar gks, i.e., the ones raised to a power zero,
% and all the others
numcomp = length(gks(:));
scind = []; % 
rind = []; % indices of regular components

for i=1:numcomp
    gks(i) = condgk( gks(i) );
    if gks(i).isScalar == 1
        scind = [scind, i];
    else
        rind = [rind, i];
    end
end
    


if ~isempty(scind)
    sc = mergescalars( gks(scind) );
end
if ~isempty(rind)
    pgks = mergeregulars( gks(rind), threshold );
end
% Cat the arrays found above
if ~isempty(scind) && ~isempty(rind)
    if abs( sc.sval )>eps
        pgks = [sc;pgks];
    end % else pgks stays as it is
% elseif isempty(scind) && ~isempty(rind) % pgks stays as it is
elseif ~isempty(scind) && isempty(rind)
    pgks = sc;
% elseif isempty(scind) && isempty(rind) % does not happen
end
if size( gks, 1) == 1
    % not column vector
    pgks = pgks';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [gkout ] = condgk(gkin)
gkout = gkin;
if gkout.isScalar == 0
    if abs( gkout.Z ) < eps
        pgks.isScalar = 1;
        pgks.sval = 0;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pgks = mergescalars( gks )
numcomp = length(gks(:));
pgks = gks(1);
for i=2:numcomp
    gkin = gks(i);
    % Check with the stored gks
    isMerged = 0;
    for j=1:length(pgks)
        gkst = pgks(j);
        if gkst.isScalar == 1 && gkin.isScalar == 1
            % Merge them
            if isMerged == 1
                error('Attempt to merge already merged');
            else
                isMerged = 1;
                mergeTo = j;
                pgks(mergeTo).sval = pgks(mergeTo).sval + gkin.sval;
            end
        end
    end
    
    if isMerged == 0
        % Not merged, cat to the array
        pgks(end+1) = gkin;
        
    end
end

pgks = pgks(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pgks = mergeregulars( gks, threshold )
numcomp = length(gks(:));
pgks = gks(1);
for i=2:numcomp
    gkin = gks(i);

    % Check with the stored gks
    isMerged = 0;
    for j=1:length(pgks)
        gkst = pgks(j);
        
        if norm( gkst.m - gkin.m  )<=threshold && norm( gkst.C - gkin.C )<=threshold
            % Merge them
            if isMerged == 1
                error('Attempt to merge already merged');
            else
                isMerged = 1;
                mergeTo = j;
                pgks(mergeTo).Z = pgks(mergeTo).Z + gkin.Z;
            end
        end
    end
    
    if isMerged == 0
        % Not merged, cat to the array
        pgks(end+1) = gkin;
    end
end

pgks = pgks(:);


