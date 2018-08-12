function varargout = draw( this, varargin )


figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
timestep = 1;

plotOpt = {'''Marker'',''.'',''LineStyle'',''None'',''Color'',[0 0 1]'};



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
            case {'options'}
                 if argnum + 1 <= nvarargin
                     plotOpt = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'precommands'}
                 if argnum + 1 <= nvarargin
                     precommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
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
loc = this.getstate({'x','y','z'});
eval(['plot3(loc(1), loc(2), loc(3),', plotOpt{1},');'] )
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
 