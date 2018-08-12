function [Ep, varargout] = tree2polytree( E, varargin )
% TREE2POLYTREE returns the edge set of a Directed Acyclic Polytree given 
% the edge set of a connected undirected acyclic graph(tree). Note that
% the childless nodes are subject to selection.
%
% Ep = tree2polytree( E ) selects 1/10 of the set of vertices that has the 
% largest degree as the childless nodes and constructs the polytree.
%
% Ep = tree2polytree( E, 'NumChildlessNodes', N) selects N of the vertices
% that has the largest degree as the childless nodes.
%
% Ep = tree2polytree( E, 'ChildlessNodes', C ) selects the vertices in the
% array C as the childless nodes
%
% [Ep,C] = tree2polytree( E ) returns the childless  nodes C. 
%
% [Ep,C,P] = tree2polytree( E ) returns the parentless nodes P.
%
% See also KRUSKAL, CONGRAPH, GGRAPH, SNEI

% Murat Uney

if nargin == 1
    if ~isnumeric(E)||ndims(E)~=2
        error('E should be a numeric array of 2-dims!');
    end
    [numEdges, N] = size(E);
    if N~=2
        error('Each edge of E should be a 2-tuple!');
    end
    C = [];
    N = [];
elseif nargin==2
    error('Not enough arguments or too many arguments!');
elseif nargin==3
    for j=1:2:length(varargin)
        if ~isnumeric( varargin{j})
            switch( lower( varargin{j}) )
                case {'numchildlessnodes'}
                    N = varargin{j+1};
                    C = [];
                case {'childlessnodes'}
                    C = varargin{j+1};
                    if ~isnumeric(C)
                        error('The childless nodes C must be a numeric array!');
                    end
                    C = C(:);
                    N = length(C);
                otherwise
                    error(sprintf( 'Unkown argument %s', varargin{j}));
            end
        else
            error('Can not parse the arguments!');
        end
    end 
end
if isempty(C)
    % The set of vertices
    V = sort(unique(E(:),'legacy'));
    % Find their degrees
    D = finddegree( E, V );
    if isempty(N)
        N = ceil( length(V)/10 );
    end
    [dummy, Cind] = sort(D,'descend');
    C(1) = V(Cind(1));
    % Select higher degree nodes that are NOT neighbors
    cntr = 2;
    for j=2:length(Cind)
        nej = union( E( find(E(:,1)==V(Cind(j))),2), E( find(E(:,2)==V(Cind(j))),1));
        if sum( ismember(C, nej) )>0 % If any of C is a neighbor of V(Cind(j))
            continue;
        else
            C(cntr) = V(Cind(j));
            cntr = cntr+1;
            if cntr > N
                break;
            end
        end
    end
    C = C(:);
end

E = sue(E);
Ep = [];

% Pivot node
pnode = C(:);
while(~isempty(pnode))
    ne1ind = find(E(:,1)==pnode(1));
    ne2ind = find(E(:,2)==pnode(1));
    Ep = [Ep; [E(ne1ind,2), E(ne1ind,1)]];
    Ep = [Ep; [E(ne2ind,1), E(ne2ind,2)]];
    pnode = [pnode(2:end); E(ne1ind,2); E(ne2ind,1)];
    E(ne1ind,:)=[];
    E(ne2ind,:)=[];
end

if ~isempty(E)
    warning('The edge set does not indicate a tree!');
end

if nargout>=2
    varargout{1} = C;
end
P = [];
if nargout == 3
    for j=1:size(Ep,1)
        if isempty( find( Ep(:,2)== Ep(j,1) ) )
            P = [P; Ep(j,1)];
        end
    end
    varargout{2} = unique(P,'legacy');
end
    
    
    
    


