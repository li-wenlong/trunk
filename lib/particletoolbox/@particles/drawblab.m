function varargout = drawblab(these, varargin)


dims = [1,2];
scale = 1;

plotOpt = {'''Marker'',''x'',''LineStyle'',''None'''};

figureHandle = [];
axisHandle = [];
legendOn = 0;
precommands = '';
postcommands = '';
isblabel = 0;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'axis'}
                if argnum + 1 <= nvarargin
                    axisHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'figure'}
                if argnum + 1 <= nvarargin
                    figureHandle = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'dims','dimensions'}
                if argnum + 1 <= nvarargin
                    dims = varargin{argnum+1}(:);
                    argnum = argnum + 1;
                end
                
            case {'postcommands'}
                if argnum + 1 <= nvarargin
                    postcommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    plotOpt = varargin(argnum+1);
                    argnum = argnum + 1;
                end
            case {'precommands'}
                if argnum + 1 <= nvarargin
                    precommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'scale'}
                if argnum + 1 <= nvarargin
                    scale = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'legend'}
                legendOn = 1;
            case {'blabel'}
                isblabel = 1;
                
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end

dstates_ = [these.states( dims ,:); these.weights'*scale ];

% Traverse the 2-depth tree and find indxs
if ~isempty( these.blabels )
    ubl = unique( these.blmap,'legacy' );
    for j=1:length(ubl)
        
        dims4bl{j} = find( these.blmap == ubl(j) ); % These are the fields of clusters
        subclusterlabels{j} = unique( these.blabels( ubl(j), :) ,'legacy' );
        %  disp(sprintf('Number of subcluster labels for field %d  is %d',j,length( subclusterlabels{j}  )));
        if j==1
        for k=1:length( subclusterlabels{j}  )
            
            subclusterind{j}{k} = find( these.blabels( ubl(j), :) ==  subclusterlabels{j}(k) );            
        end
        elseif j>1
            for jj=1:length( subclusterlabels{j-1} ) % For each parent in the upper level
                for k=1:length( subclusterlabels{j} )
                  pind = find( these.blabels( ubl(j), subclusterind{j-1}{jj} ) ==  subclusterlabels{j}(k) );
                  subclusterind{j}{ (jj-1)*length( subclusterlabels{j} ) + k} = subclusterind{j-1}{jj}(pind);
                end
            end
            
        end
    end
end

% Find the cluster weights
for i = 1:length( subclusterind{2} ) % Clusters at level 2
    indx = subclusterind{2}{i}; % This is level 1
    clusterweights(i) = sum( these.weights(indx) );
end

[sweights, cind ] = sort( clusterweights, 'descend' );


if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end


rgbObj = rgb;
axes(axisHandle);
if ~isempty(precommands)
    eval(precommands);
end
hold on
grid on

lHandles = [];
lString = '';


for i=1:length( cind)
    clabel =  i; % subclusterlabels{2}( cind( i ) );
    indx = subclusterind{2}{i}; % This is level 1
    tw = sweights(i);
    
    colstr = num2str( getcol(rgbObj) );
    
    
    eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
        [plotOpt{1},',''Color'',[', colstr ,']'],');'] );
    lHandles = [ lHandles, l ];
    lString = [lString,'''',num2str( clabel ),'(', num2str(tw),')'','];
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if legendOn
   eval(['legend(lHandles,',lString(1:end-1),');']); 
end
if ~isempty(postcommands)
    eval( postcommands)
end     
hold off


if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end

