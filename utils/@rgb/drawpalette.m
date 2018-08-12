function varargout = drawpalette(r, varargin)


plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};

plotOpt = {''};

figureHandle = [];
axisHandle = [];

for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

numColors = size(r.palette , 1);

axes(axisHandle);
hold on
grid on
for i=1:numColors
    if ~isempty( plotOpt{1} )
        plotOpts = [plotOpt{1},'Color,','[',num2str(r.palette(i,:)) ,']'];
    else
        plotOpts = ['''Color'',','[',num2str(r.palette(i,:)) ,']'];
    end
    eval(['plot3([1,',num2str(numColors),'],[',num2str(i),',',num2str(i),'], [0,0],', plotOpts,');'] );
end
hold off

if nargout>0
    varargout{1} = axisHandle;
end