function varargout = plotset(Xh, varargin )

if iscell(Xh)
   
   %if length(Xh)>=2
   %remX = Xh(2:end);
   %end
   Xharray = cell2mat(Xh);
   %Xh = Xh{1};
else
    Xharray = Xh;
end



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

plotOpt = '''Marker'',''o'',''LineStyle'',''None'',''Color'',[0 1 0]';
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

 rgbobj = rgb;
 for i=1:size( Xharray, 2)
     if switchcolor
         col = rgbobj.getcol;
         
         eval(['plot3(Xharray( dims(1), i)*scale,  Xharray( dims(2) ,i)*scale,',num2str(shift) ,',', plotOpt,',''Color'',[' num2str(col), ']);'] );
         
         
     else
         eval(['plot3(Xharray( dims(1), i)*scale, Xharray( dims(2) ,i)*scale,',num2str(shift) ,',', plotOpt,');'] )
     end
     if isvel
         p1 = [ Xharray( dims(1), i)*scale,  Xharray( dims(2) ,i)*scale] ;
         velvect =  [ Xharray( veldims(1), i)*scale,  Xharray( veldims(2) ,i)*scale];
         p2 = p1 + 100*velvect/sqrt( velvect(1)^2 + velvect(2)^2 );
         if switchcolor
             
             eval(['plot3( [p1(1) p2(1)] ,[p1(2) p2(2)],[',num2str([shift shift]),'],', plotOpt,',''Color'',[', num2str(col), '],''LineStyle'',''-'',''Marker'',''none'');'] );
             
             
         else
             eval(['plot3( [p1(1) p2(1)] ,[p1(2) p2(2)],[',num2str([shift shift]),'],' plotOpt,',''LineStyle'',''-'',''Marker'',''none'');'] )
         end
     end
 end
 
 if isdisporder
     if iscell( Xh )
         for ocnt=1:length(Xh)
             for ecnt = 1:size( Xh{ocnt}, 2)
                 %eval([ 'text( Xh{ocnt}( dims(1), ecnt ),  Xh{ocnt}( dims(2) , ecnt),', num2str( ocnt ), ',', plotOpt,');'] )
                 text( Xh{ocnt}( dims(1), ecnt )*scale,  Xh{ocnt}( dims(2) , ecnt)*scale,num2str( ocnt ) ) ;
             end
         end
     else
         rgbobj = rgb;
         for ocnt=1:size(Xh,2)
             text( Xh( dims(1), ocnt )*scale,  Xh( dims(2) , ocnt)*scale, shift*1.1, num2str( ocnt ), 'Color', rgbobj.getcol ,'Fontsize',14 ) ;
         end
     end
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
