function varargout = draw( this, varargin )


plotOpt = 'b.';

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
else
    if isempty(figureHandle)
        figureHandle = gcf;
    end
end

 axes(axisHandle);
 hold on
 grid on
 
 for i=1:length( this.treps )
     myplotOpt{1} = plotOpt{1};
     if i==1
       myplotOpt{1} = [plotOpt{1},',''Marker'',''o'''];
     end
     this.treps(i).state.draw( 'axis', axisHandle, 'options',myplotOpt(1) );
    % loc = this.treps(i).state.getstate({'x','y','z'});
    % text( loc(1), loc(2), loc(3), num2str(this.treps(i).time));
 end
 hold off
 
 
 
        

