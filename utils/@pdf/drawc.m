function varargout = drawc(pdf, varargin)

dims = [1,2];
scale = 1;

plotOpt = {'''Marker'',''x'',''LineStyle'',''None'''};

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
isGMM = 0;
isKDE = 1;
legendOn = 0;
nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( lower(varargin{argnum}), 'char')
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
            case {'gmm'}
                isGMM = 1;
                isKDE = 0;
                
            case {'kde'}
                isKDE = 1;
                isGMM = 0;
                
                
            case {'legend'}
                legendOn = 1;
                
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;
end


if isKDE
zs = pdf.evaluate('kde');
elseif isGMM
zs = pdf.evaluate('gmm');
else
zs = weights_';
end
zs = zs(:)*scale;
states_ = pdf.particles.getstates;

[d, Nc] = size( states_ );
if d>=2
    dstates_ = [states_(dims,:); zs' ];
else
    dstates_ = [states_([1],:); zeros( 1, Nc); zs' ];
end

% Sort the clusters that are not labelled as zero according to their
% weights
labels_ = pdf.particles.getlabels ;
clusterNames = sort( unique( labels_ ,'legacy') );
weights_ = pdf.particles.getweights;

nzclusters = clusterNames( find(clusterNames~=0) );
nzclusterweights = [];

for i=1:length( nzclusters )
    indx = find( labels_ == nzclusters(i) );
    nzclusterweights(i) = sum( weights_(indx) );
end

[sweights, nzind ] = sort( nzclusterweights, 'descend' );


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

% First, draw the zero labels
indx = find( labels_ == 0 );
if ~isempty( indx  )
    colstr = num2str( getcol(rgbObj) );
     tw = sum( weights_(indx) );
    eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
        [plotOpt{1},',''Color'',[', colstr ,']'],');'] );
    lHandles = [ lHandles, l ]; 
    lString = [lString,'''',num2str( 0 ),'(', num2str(tw),')'','];
     getcol(rgbObj); % Waste the second
else
    getcol(rgbObj); % Waste the first
     getcol(rgbObj); % Waste the second
end

% Then, the non-zero labelled clusters
if ~isempty( nzclusters )
    for i=1:length(nzind)
        clabel =  nzclusters( nzind( i ) );
        indx = find( labels_ == clabel );
        tw = sweights(i);
        
        colstr = num2str( getcol(rgbObj) );
       
        
        eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
            [plotOpt{1},',''Color'',[', colstr ,']'],');'] );
        lHandles = [ lHandles, l ];
        lString = [lString,'''',num2str( clabel ),'(', num2str(tw),')'','];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if legendOn
   eval(['legend(lHandles,',lString(1:end-1),');']); 
end
if ~isempty(postcommands)
    eval( postcommands)
end     
hold off




% lHandles = [];
% lString = '';
% for i=length( clusterNames ):-1:1
%     indx = find( labels_ == clusterNames(i) );
%    % tw = sum( these.weights(indx) );
%     eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
%         [plotOpt{1},',''Color'',[', num2str( getcol(rgbObj) ) ,']'],');'] );
%     lHandles = [ lHandles, l ]; 
%     lString = [lString,'''',num2str( clusterNames(i)  ),''',']; %,'(', num2str(tw),')'','];
% end
% if legendOn
%    eval(['legend(lHandles,',lString(1:end-1),');']); 
% end
% if ~isempty(postcommands)
%    eval(postcommands); 
% end        
% hold off


if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end

