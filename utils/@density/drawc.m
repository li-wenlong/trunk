function drawc(pdf, varargin)

labels_ = pdf.particles.getlastlabel ;
clusterNames = unique( labels_,'legacy' );
dims = [1,2];


plotOpt = {'''Marker'',''x'',''LineStyle'',''None'''};

figureHandle = [];
axisHandle = [];
isGMM = 1;
isKDE = 0;
legendOn = 0;
inctrl = 0; % This is to check numerical input arguments preceded by a string
for cnt=1:length(varargin)
    if strcmp( lower( varargin{cnt} ), 'gmm' )
        isGMM = 1;
        isKDE = 0;
    elseif strcmp( lower( varargin{cnt} ), 'kde' )
        isKDE = 1;
        isGMM = 0;
        
    elseif strcmp( lower( varargin{cnt} ), 'legend' )
        legendOn = 1;
    elseif ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'dims' ) || strcmp( lower( varargin{cnt} ), 'dimensions' )
            dims  = varargin{cnt+1};
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
        cnt = cnt+1;
        incntrl = 1;
    else
        if inctrl == 0
            error('Wrong input string');
        else
            inctrl = 0;
        end
    end
end

if isKDE
zs = pdf.evaluate('kde', pdf.particles.catstates);
elseif isGMM
zs = pdf.evaluate('gmm', pdf.particles.catstates );
else
zs = these.weights';
end
zs = zs(:);
states_ = pdf.particles.catstates;

[d, Nc] = size( states_ );
if d>=2
    dstates_ = [states_(dims,:); zs' ];
else
    dstates_ = [states_([1],:); zeros( 1, Nc); zs' ];
end


if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end


rgbObj = rgb;
axes(axisHandle);
hold on
grid on

lHandles = [];
lString = '';
for i=length( clusterNames ):-1:1
    indx = find( labels_ == clusterNames(i) );
   % tw = sum( these.weights(indx) );
    eval(['l = plot3(dstates_(1,indx), dstates_(2,indx), dstates_(3,indx),', ...
        [plotOpt{1},',''Color'',[', num2str( getcol(rgbObj) ) ,']'],');'] );
    lHandles = [ lHandles, l ]; 
    lString = [lString,'''',num2str( clusterNames(i)  ),''',']; %,'(', num2str(tw),')'','];
end
if legendOn
   eval(['legend(lHandles,',lString(1:end-1),');']); 
end
        
hold off

