function varargout = drawgeograph( loc, E, varargin )
% DRAWGEOGRAPH draws edges of a geographic undirected graph
% drawgeograph( loc, E ) opens a new figure, locates the nodes at locations
% given by loc and connects neigbors as given in the edge set E.
% drawgeograph( loc, E, 'AxisHandle', ah ) draws the graph on the axis
% whose axis is given by ah.
% drawgeograph( loc, E, LineSpec ) draws the edges considering LineSpec
% H = drawgeograph() returns the axis handle
%
% See also DRAWDIRGEOGRAPH, CONGRAPH, GGRAPH

% Murat Uney
if nargin < 2
    error('Not enough input arguments!');
elseif nargin >= 2
    if length(size(loc))~=2
        error('The array of node locations is an Nx2 array');
    end
    if ~isnumeric(loc)
        error('The array of node locations should be of type numeric!');
    end
    if length(size(E))~=2
        error('The array of node locations is an Nx2 array');
    end
    if ~isnumeric(E)
        error('The array of node locations should be of type numeric!');
    end
end
newFig = 1;
LineSpec = '';
if nargin>2   
    for j=1:2:length(varargin)
        if ~isnumeric( varargin{j})
            switch( lower( varargin{j}) )
                case {'axishandle'}
                    aHandle = varargin{j+1};
                    newFig = 0;      
                     
                otherwise
                    LineSpec = [LineSpec,',''',varargin{j}, ''',varargin{', num2str(j+1),'}']; 
                    
            end
        else
            error('Can not parse LineSpec!');
        end
    end
end
varargout = {};
if newFig == 1
    figure;
    aHandle = gca;
end
hold on
for e = 1:size(E,1) % For each edge
    eval(['plot( [loc(E(',num2str(e),',1),1),loc(E(',num2str(e),',2),1)], [loc(E(',...
        num2str(e),',1),2),loc(E(',num2str(e),',2),2) ]',LineSpec,');'] );
end
hold off
if nargout == 1
    varargout{1} = aHandle;
end
                
            
            