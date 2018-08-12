function varargout = draw(pdf, varargin)


plotOpt = {'''LineStyle'',''none'',''Marker'',''.'',''Color'',[0 0 1]'};
dims = [1,2];

figureHandle = [];
axisHandle = [];

isGMM = 1;
isKDE = 0;
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'dimensions' ) || strcmp( lower( varargin{cnt} ), 'dims' )
            dims = varargin{cnt+1};
            
            
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    elseif strcmp( lower( varargin{cnt} ), 'gmm' )
        isGMM = 1;
        isKDE = 0;
    elseif strcmp( lower( varargin{cnt} ), 'kde' )
        isKDE = 1;
        isGMM = 0;
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

if isKDE
zs = pdf.evaluate('kde');
elseif isGMM
zs = pdf.evaluate('gmm');
else
zs = these.weights';
end
zs = zs(:);
states_ = pdf.particles.getstates;

[d, Nc] = size( states_ );
if d>=2
    dstates_ = [states_(dims,:); zs' ];
else
    dstates_ = [states_([1],:); zeros( 1, Nc); zs' ];
end
axes(axisHandle);
hold on
grid on

eval(['plot3(dstates_(1,:), dstates_(2,:), dstates_(3,:),', plotOpt{1},');'] )
hold off

if nargout>0
    varargout{1} = axisHandle;
end
if nargout>1
    varargout{1} = figureHandle;
end
