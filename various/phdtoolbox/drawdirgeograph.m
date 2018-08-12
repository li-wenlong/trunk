function varargout = drawdirgeograph( loc, E, varargin )
% DRAWDIRGEOGRAPH draws directed geographic graph
% drawdirgeograph( loc, E ) opens a new figure, locates the nodes at locations
% given by loc and connects nodes as given in the edge set E.
% drawdirgeograph( loc, E, 'AxisHandle', ah ) draws the graph on the axis
% whose axis is given by ah.
% drawdirgeograph( loc, E, LineSpec ) draws the edges considering LineSpec
% H = drawgeograph() returns the axis handle
%
% See also DRAWGEOGRAPH, TREE2POLYTREE

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
    arrowHeadC = [0 0 1];
end
newFig = 1;
LineSpec = [''];
isEdgeTags = 0;
if nargin>2   
    for j=1:2:length(varargin)
        if ~isnumeric( varargin{j})
            switch( lower( varargin{j}) )
                case {'axishandle'}
                    aHandle = varargin{j+1};
                    newFig = 0;
                case {'color'}
                    LineSpec = [LineSpec,',''',varargin{j}, ''',varargin{', num2str(j+1),'}'];
                    arrowHeadC = varargin{j+1};
                case {'edgetags'}
                    edgeTags = varargin{j+1};
                    isEdgeTags = 1;
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
% for e = 1:size(E,1) % For each edge
%     eval(['plot( [loc(E(',num2str(e),',1),1),loc(E(',num2str(e),',2),1)], [loc(E(',...
%         num2str(e),',1),2),loc(E(',num2str(e),',2),2) ]',LineSpec,');'] );
% end
U = zeros(size( E,1 ),1 );
V = zeros(size( E,1 ),1 );

X = zeros(size( E,1 ),1 );
Y = zeros(size( E,1 ),1 );

for i = 1:size( E,1 )
    V(i) = loc(E(i,2) ,2) - loc(E(i,1),2);
    U(i) = loc(E(i,2) ,1) - loc(E(i,1),1);
end

regionScaleX = (max(loc(:,1)) - min(loc(:,1)))/2;
regionScaleY = (max(loc(:,2)) - min(loc(:,2)))/2;

for i=1:size( E,1 )

    arrowHeadX = [0 0 1]';
    arrowHeadY = 2*[-0.125,0.125,0]';
    
    v = [U(i),V(i)]';
    normV = norm(v);
    argV = atan2(v(2),v(1));
    
    % Scale the arrow head
    arrowHeadX = arrowHeadX*normV/3;
    arrowHeadY = arrowHeadY*normV/3;
    
    % Shift the arrow head
    arrowHeadX = arrowHeadX+normV-max(arrowHeadX);
    
    
    % Rotate the arrow head
    alpha = argV;
    rotM = [cos(alpha), -sin(alpha);sin(alpha), cos(alpha)];
    arrowHeadR = rotM*[arrowHeadX';arrowHeadY'] + [loc(E(i,1),1),loc(E(i,1),1),loc(E(i,1),1);loc(E(i,1),2),loc(E(i,1),2),loc(E(i,1),2) ];
    
    eval(['plot( [loc(E(',num2str(i),',1),1),loc(E(',num2str(i),',2),1)], [loc(E(',...
        num2str(i),',1),2),loc(E(',num2str(i),',2),2) ]',LineSpec,');'] );
        
    patch(arrowHeadR(1,:)',arrowHeadR(2,:)', arrowHeadC,'EdgeColor', arrowHeadC);
    
    if isEdgeTags == 1
        if length( edgeTags )>= i
            edgeTag = edgeTags{i};
            if ~isempty(edgeTag)
                text( regionScaleX*0.01+(loc(E(i,1),1) + loc(E(i,2),1))/2, regionScaleY*0.01+( loc(E(i,1),2) + loc(E(i ,2),2) )/2   ,edgeTag,'Color','y');
            end
        end
    end
           

    % LineSpec = [LineSpec, ',''HeadStyle'',''vback1'',''HeadWidth'',',num2str( sqrt(V(i)^2+U(i)^2)/15 ),',''HeadLength'',', num2str( sqrt(V(i)^2+U(i)^2)*3/15 ) ];
    %annotation('arrow',[loc(E(i,1),1) , loc(E(i,1),2)],[loc(E(i,2),1) , loc(E(i,2),2)]);
    %  eval(['qgh = quiver( loc(E(i,1),1) , loc(E(i,1),2) , U(i), V(i), 0',LineSpec,');']);
    %  set(qgh,'MaxHeadSize', sqrt(V(i)^2+U(i)^2)/3); %,'MarkerSize',sqrt(V(i)^2+U(i)^2)/4,'Marker','v' );
end


hold off
if nargout == 1
    varargout{1} = aHandle;
end
                
            
            