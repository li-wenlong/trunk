function varargout = show( this, varargin )

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
timestep = this.track.treps(end).time;
ctrack = 0;

trackplotOpt = '''Marker'',''.'',''LineStyle'',''None'',''Color'',[0 0 1]';
obsplotOpt = '''Marker'',''x'',''LineStyle'',''None'',''Color'',[0 1 0]';
obsplotOpts = {obsplotOpt};

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
            case {'trackplotoptions'}
                 if argnum + 1 <= nvarargin
                     trackplotOpt = [trackplotOpt,',', varargin{argnum+1}];
                     argnum = argnum + 1;
                 end
             case {'obsplotoptions'}
                 if argnum + 1 <= nvarargin
                     obsplotOpts = varargin{argnum+1};
                     for j=1:length( obsplotOpts )
                         obsplotOpts{j} = [ obsplotOpt,',', obsplotOpts{j}];
                     end
                     argnum = argnum + 1;
                 end
             case {'precommands'}
                 if argnum + 1 <= nvarargin
                     precommands = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'time'}
                 if argnum + 1 <= nvarargin
                     timestep = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'ctrack'}
                 if argnum +  1 <= nvarargin
                     ctrack = varargin{argnum+1};
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

% Get the tracks drawn
this.track.show(  'axis', axisHandle, ...
    'figure',figureHandle, ...
    'time', timestep,...
    'precommands', precommands,...
    'postcommands', postcommands,...
    'options', trackplotOpt,...
    'ctrack', ctrack...
    );

obsplotoptcnt = 1;
for i=1:length(this.sensors)

    this.sensors{i}.show(  'axis', axisHandle, ...
        'figure',figureHandle, ...
        'time', timestep,...
        'precommands', precommands,...
        'postcommands', postcommands,...
        'overidecolor', 1,...
        'options', obsplotOpts{obsplotoptcnt}...
        ) ;
    obsplotoptcnt = obsplotoptcnt + 1;
    if obsplotoptcnt > length( obsplotOpts )
        obsplotoptcnt = 1;
    end
end


if nargout>=1
     varargout{1} = axisHandle;
end
if nargout>=2
     varargout{2} = figureHandle;
end
