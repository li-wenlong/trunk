function varargout = displaycardbuffer(this, varargin )


plotOpt = {'','','',''};
figureHandle = [];
axisHandles = [];
clearAxis = 0;
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'step' )
            stepNum = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandles = varargin{cnt+1};
         elseif strcmp( lower( varargin{cnt} ), 'cla' )
            clearAxis = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

if length(plotOpt) == 1
    for i=2:4
        plotOpt{i} = plotOpt{1};
    end
end
if ~isempty( plotOpt{1} )
    plotOpts{1} =  ['''Color'',''b'',',plotOpt{1}];
else
    plotOpts{1} =  ['''Color'',''b'''];
end

if ~isempty( plotOpt{2} )
    plotOpts{2} =  ['''Color'',''r'',',plotOpt{2}];
else
    plotOpts{2} =  ['''Color'',''r'''];
end
if ~isempty( plotOpt{3} )
    plotOpts{3} =  ['''Color'',''g'',',plotOpt{3}];
else
    plotOpts{3} =  ['''Color'',''g'''];
end


if ~isempty(  plotOpt{4} )
    plotOpts{4} =  ['''Color'',''m'',',plotOpt{4}]; 
else
    plotOpts{4} =  ['''Color'',''m'''];
end

if isempty(axisHandles)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    figure(figureHandle)
    clf
    % Prepare the axis
    axisHandles(1) = gca;

else
    if clearAxis
        for i=1:length( axisHandles )
            axes( axisHandles(i) );
            cla;
        end
    end
end


if ~isempty( this.postcardbuffer )
    numsteps = length( this.postcardbuffer );
    
    postcardmaxs = [];
    postcardmeans = [];
    detmaxs = [];
    undetmaxs = [];
    persmaxs = [];
    for j=1:numsteps
      [maxval, ind ] = max( this.postcardbuffer{j} );
      postcardmaxs(j) = ind - 1;
      postcardmeans(j)  = sum( this.postcardbuffer{j}.*[0:length(this.postcardbuffer{j})-1]' );
      
           
      
    end
      
      axes( axisHandles(1) );
      
      hold on;
      grid on;
      eval([' plot( [0:length(postcardmaxs)-1], postcardmaxs,', plotOpts{1},');'] );
      eval([' plot( [0:length(postcardmaxs)-1], postcardmeans,', plotOpts{2},');'] );
      hold off;
     
%      if length( axisHandles )>1
%          axes( axisHandles(2) );
%      end
%     
%       hold on;
%       grid on;
%       
%      eval([' plot( [0:length(persmaxs)-1], persmaxs,', plotOpts{4},');'] );
%      hold off;
%      
end    

if nargout>=1
    varargout{1} = axisHandles;
end
