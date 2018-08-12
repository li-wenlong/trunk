function [varargout] = draw(these, varargin)

dims = [1,2];
plotOpt = {'''LineStyle'',''-'',''Color'',[0 0 1]'};

shift = 0;
scale = 1;
postcommands = '';
precommands = '';
figureHandle = [];
axisHandle = [];
isEval = 0;
isPlotOpt = 0;
evalpts = [];
nvarargin = length(varargin);
argnum = 1;
stdfac = 3;
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
            case {'eval'}
                if argnum + 1 <= nvarargin
                    evalpts = varargin{argnum+1}(:);
                    isEval = 1;
                    argnum = argnum + 1;
                end    
            case {'postcommands'}
                if argnum + 1 <= nvarargin
                    postcommands = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'options'}
                if argnum + 1 <= nvarargin
                    isPlotOpt = 1;
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
            case {'stdfactor'}
                if argnum + 1 <= nvarargin
                    stdfac = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case {'shift'}
                if argnum + 1 <= nvarargin
                    shift = varargin{argnum+1};
                    argnum = argnum + 1;
                end
            case{'gmm'}
                argnum = argnum + 1;
                continue;
            otherwise
                error('Wrong input string');
        end
    end
    argnum = argnum + 1;   
end

[Nc] = length(these);
if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = repmat( [gca], 1, Nc);
end

mymap = colormap;

numdims = length( dims );
switch numdims 
    case {1}   
        for k=1:length( these(1).pdfs )
            axes(axisHandle(1));
            if ~isempty(precommands)
                eval(precommands);
            end
            
            hold on
            grid on
            
            if ~isEval
                stdvar = sqrt( these(k).C(1,1) );
                evalpts = [-3*stdvar:(6*stdvar/250):3*stdvar];
            else
                evalpts = ( evalpts(:) )';
            end
            ypts = these(k).evaluate( evalpts);
            crrntColor = mymap( ceil( length(mymap)*( these(1).w(k)   ) ) ,:);
            eval(['plotHandle(k) = plot( evalpts, ypts,', plotOpt{1},',''Color'',crrntColor);'] );
            
            if ~isempty(postcommands)
                eval( postcommands)
            end
            hold off
        end
    otherwise
        dims = dims([1,2]);
        
        lenpts = 100;
        circpts = [cos([0:2*pi/(lenpts-1):2*pi]);sin([0:2*pi/(lenpts-1):2*pi])];
        myeps = 1.0e-8;
        
        % Here, we plot all on the same axis?
        if length(axisHandle) == length( these(1).pdfs )
            isPerAxis = 1;
        else
            isPerAxis = 0;
        end
        axes(axisHandle(1));
        if ~isempty(precommands)
            eval(precommands);
        end
        hold on
        grid on
        [sw, sind] = sort( these(1).w,'ascend' );
        for k=1:length(these(1).pdfs)
            m_ = these(1).pdfs(sind(k)).m(dims);
            crrntColor = mymap( ceil( length(mymap)*( these(1).w(sind(k))   ) ) ,:);
            
            [E,S] = eig( these(1).pdfs(sind(k)).C(dims,dims) ); % Lambda_p = E*S*E'
            
            ellpts = E([1,2],1)*(E([1,2],1)'*circpts*stdfac*sqrt( S(1,1) ) )  + E([1,2],2)*( E([1,2],2)'*circpts*stdfac*sqrt( S(2,2) ) ); % points on the ellipse
            sellpts = repmat(m_,1, lenpts) + ellpts ; % points on the ellipse shifted to the mean
            
            eval(['plot3( sellpts( 1,:) , sellpts( 2 ,:),shift+scale*these(1).w(sind(k))*ones(1,lenpts) ',',', plotOpt{1},',''Color'',crrntColor);'] );
            eval(['plot3( m_( 1) , m_( 2 ),shift+scale*these(1).w(sind(k))',',', plotOpt{1},',''Marker'',''.'',''Color'',crrntColor);'] );        
        end
        if ~isempty(postcommands)
            eval( postcommands)
        end
        hold off
end



if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end
if nargout>=3
    varargout{3} = plotHandle;
end
