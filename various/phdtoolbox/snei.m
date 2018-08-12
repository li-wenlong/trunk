function Es = snei( E, varargin )
% SNEI Sparsify neighbors of i; sparsifies an edge set E by dropping edges 
% between two vertices such that the neighbors of the first has stronger 
% edges with the second regarding the weights corresponding to edges 
% given by w.
% Es = snei( E, w ) performs the sparsification.
% Es = snei( E, w, 'Loc' ) performs the sparsification by considering the
% array w, as the location of nodes and weight of edges are inversely
% proportional with the distance
%
% See also CONGRAPH, GGRAPH, DELGRAPH

% Murat Uney

if nargin<2
    error('Not enough input arguments');
end
if nargin == 2
    if ~isnumeric(varargin{1})
        error('First two arguments should be of type numeric!');
    end
    w = varargin{1};
    if length(w)~= size(E,1)
        error('The weight vector should be of length the number of edges!');
    end
elseif nargin == 3
    if isnumeric( varargin{2} )
        error('Third argument should be of type string!');
    end
    if strcmp(lower(varargin{2}),'loc')
        w = 1./sqrt( sum( ( varargin{1}(E(:,1))-varargin{1}(E(:,2)) ).*( varargin{1}(E(:,1))-varargin{1}(E(:,2)) ),2 ) );
    else
        error('Third argument is wrong!');
    end
elseif nargin>3
    error('Too much input arguments!')
end


for e = 1:size(E,1)
    if E(e,1) == 0 & E(e,2) == 0
        continue;
    else
        % Find the neigbors of E(e,1)
        % 1. children
        childNodes =  unique( setdiff( E( find( E(e,1) == E(:,1) ) ,2), E(e,1) ),'legacy');
        parentNodes = unique( setdiff( E( find( E(e,1) == E(:,2) ) ,1), E(e,1) ),'legacy');
        neighbors = [childNodes; parentNodes];
        % Check if removing an edge from E(e,1) renders it of degree 2
        if length(neighbors)<3
            continue;
        end
        % Check if removing an edge from E(e,2) renders it of degree 2
        childNodesOfSecond =  unique( setdiff( E( find( E(e,2) == E(:,1) ) ,2), E(e,2) ),'legacy');
        parentNodesOfSecond = unique( setdiff( E( find( E(e,2) == E(:,2) ) ,1), E(e,2) ),'legacy');
        neighborsOfSecond = [childNodesOfSecond; parentNodesOfSecond];
        if length(neighborsOfSecond)<3
            continue;
        end
        
        % For each neighbor check
        for ne = 1:length(neighbors)
            edgesFromNei = find( neighbors(ne) == E(:,1));
            edgesToNei = find( neighbors(ne) == E(:,2));
            
            ne2 = [ E(edgesFromNei,2); E(edgesToNei,1) ];
            ne2Index = [edgesFromNei;edgesToNei];
            common = find( ne2 == E(e,2));

           if ~isempty( common )
               if w( e ) < w( ne2Index(common))
                  E(e,:) = [0,0];
               else
                   % Check if removing this edge renders this node as 
                   % degree 1
                    if length( unique( ne2),'legacy' )>=3
                       E(ne2Index(common),:)=[0,0];
                   end
               end
           end
        end % for ne
    end % if
end % outer loop

Es = sue(E);
