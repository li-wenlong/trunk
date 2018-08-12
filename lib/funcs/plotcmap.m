function varargout = plotcmap( p, w, varargin )

switchcolor = 0;   
figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
dims = [1,2]';
isvel = 0;
veldims = [3,4]';
shift = 0;
scale = 1;

plotOpt = '''Marker'',''.'',''LineStyle'',''None'',''Color'',[0 1 0]';
isdisporder = 0;

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
             case {'postcommands'}
                 if argnum + 1 <= nvarargin
                     postcommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'precommands'}
                 if argnum + 1 <= nvarargin
                     precommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'dims'}
                 if argnum + 1 <= nvarargin
                     dims = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'velocitydims'}
                 if argnum + 1 <= nvarargin
                     veldims = varargin{argnum+1};
                     isvel = 1;
                     argnum = argnum + 1;
                 end
             case {'shift'}
                 if argnum + 1 <= nvarargin
                     shift = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'scale'}
                 if argnum + 1 <= nvarargin
                     scale = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'options'}
                 if argnum + 1 <= nvarargin
                     plotOpt = [plotOpt,',', varargin{argnum+1}];
                     argnum = argnum + 1;
                 end
             
             case {'disporder'}
                 isdisporder = 1;
            case {'switchcolor'}
                 switchcolor = 1;       
             otherwise
                 error('Wrong input string');
         end
     end
     argnum = argnum + 1;
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
if ~isempty(precommands)
    eval( precommands );
end

colors = colormap;
numcolors = size( colors, 1 );
minw = min( w );
maxw = max( w );
drw = maxw - minw;

[numd, numpars] = size( p );
for i=1:numpars
    colin = round( ( (w(i) - minw )/drw )*(numcolors-1)+1 );
    colin = max( min( numcolors, colin ), 1);
    
    col = colors( colin, : );
    eval(['plot3(p( dims(1), i)*scale,  p( dims(2) ,i)*scale,',num2str(w(i)) ,',', plotOpt,',''Color'',[' num2str( col ), ']);'] );
end




if ~isempty(postcommands)
    eval(postcommands );
end
hold off


if nargout>=1
    varargout{1} = axisHandle;
end
if nargout>=2
    varargout{2} = figureHandle;
end
