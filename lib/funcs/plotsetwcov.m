function varargout = plotsetwcov(Xh, Cs, varargin )




figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
dims = [1,2]';
shift = 0;
stdfac = 1;
scale = 1;

warningswitch = 1;
switchcolor = 0;

covplotOpt = '''Marker'',''None'',''LineStyle'',''-'',''Color'',[0 1 0]';
setplotOpt = '''Marker'',''o'',''LineStyle'',''None'',''Color'',[0 1 0]';


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
             case {'setoptions'}
                 if argnum + 1 <= nvarargin
                     setplotOpt = [setplotOpt,',', varargin{argnum+1}];
                     argnum = argnum + 1;
                 end
             case {'covoptions'}
                 if argnum + 1 <= nvarargin
                     covplotOpt = [covplotOpt,',', varargin{argnum+1}];
                     argnum = argnum + 1;
                 end
             case {'scale'}
                 if argnum + 1 <= nvarargin
                     scale = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'warningoff'}
                 warningswitch = 0;
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
    else 
        figure( figureHandle );
        axisHandle = gca;
    end
else
    axisHandle = gca;
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


lenpts = 100;
circpts = [cos([0:2*pi/(lenpts-1):2*pi]);sin([0:2*pi/(lenpts-1):2*pi])];
myeps = 1.0e-8;
 
if isnumeric( Cs )
    if ndims(Cs)==3
        for i=1:size(Cs,3)
            Csc{i} = Cs(:,:,i);
        end
        Cs = Csc;
    end
    
end
rgbobj = rgb; 
for i=1:size( Cs, 2)
     m = Xh(dims,i)*scale;
     C = Cs{i}(dims,dims)*scale^2;
     
    
     
     ischolok = 0;
     if rcond(C) > eps
         % the number of different states exceeds the number of dims.
         [V,D] = eig(C);
         eigs = diag(D);
         
         cind = find(eigs<eps);
         if ~isempty( cind  )
             eigs(cind) = 1.0e-10;
             D = diag(eigs);
             C = V*D*V';
         end
         
         R = chol(C)';
         ischolok = 1;
             
         
     else
         % possible particles deprivation
         if warningswitch
             warning(sprintf('Possibly less particles than the dims, assigning min. possible C!'));
         end
         iswarning = 2;
         
         C = myeps*eye(length(dims));
         C = (C+C')/2; % take the symmetric part
         R = chol(C)';
         ischolok = 1;
         
     end
     
     if ischolok == 0
         if warningswitch
             warning(sprintf('Weird condition -- possible particle deprivation, assigning min. possible C!'));
         end
         iswarning = 3;
         
         C = myeps*eye(length(dims));
         C = (C+C')/2; % take the symmetric part
         R = chol(C)';
     end
     
     Rinv = R^(-1);
     Lambda_p = Rinv'*Rinv;

     [E,S] = eig( C ); % Lambda_p = E*S*E'
     
     ellpts = E([1,2],1)*(E([1,2],1)'*circpts*stdfac*sqrt( S(1,1) ) )  + E([1,2],2)*( E([1,2],2)'*circpts*stdfac*sqrt( S(2,2) ) ); % points on the ellipse
     sellpts = repmat(m,1, lenpts) + ellpts ; % points on the ellipse shifted to the mean
     if switchcolor
         col = rgbobj.getcol;
         
         eval(['plot3( m(1), m(2),',num2str(shift) ,',', setplotOpt,',''Color'',[' num2str(col), ']);'] );
         eval(['plot3( sellpts( 1,:) , sellpts( 2 ,:),shift*ones(1,lenpts)',',', covplotOpt,',''Color'',[' num2str(col), ']);'] );
         
         
     else
     eval(['plot3( m(1)*scale, m(2)*scale,',num2str(shift) ,',', setplotOpt,');'] )
     eval(['plot3( sellpts( 1,:) , sellpts( 2 ,:),shift*ones(1,lenpts)',',', covplotOpt,');'] );
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
