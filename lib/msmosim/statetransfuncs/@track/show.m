function varargout = show( this, varargin )

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
timestep = 1;
ctrack = 0;

plotOpt = '''Marker'',''.'',''LineStyle'',''None'',''Color'',[0 0 1]';



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
                     plotOpt = [plotOpt, ',' ,varargin{argnum+1}];
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

timestamps = cell2mat({this.treps(:).time});

ind = find( timestamps == timestep );

if ~isempty(ind)
    i = ind(1);
    
    if this.treps(i).time == timestep
        if ctrack == 1
            % Put the track from the beginning
            states = [];
            for j=i-1:-1:1
                states(:,j) = this.treps(j).state.state(1:3);
            end
            if ~isempty(states)
                figure( figureHandle )
                axes(axisHandle);
                hold on
                grid on
                if ~isempty(precommands)
                    eval( precommands );
                end
                H = eval(['plot3(NaN, NaN, NaN,', [plotOpt,',''Marker'',''.'''],');'] );
                if ~isempty(postcommands)
                    eval(postcommands );
                end
                hold off
                set( H, 'XData', states(1,:), 'YData', states(2,:), ...
                    'ZData', states(3,:) );
                
            end
%             for j=i-1:-1:1
%                 
%                 cell2mat( {this.treps(j:-1:1).state.state } )
%                 this.treps(j).state.draw(  'axis', axisHandle, ...
%                     'figure',figureHandle, ...
%                     'precommands', precommands,...
%                     'postcommands', postcommands,...
%                     'options', {[plotOpt,',''Marker'',''.''']}...
%                     );
% %                 this.treps(j).state.draw(  'axis', axisHandle, ...
% %                     'figure',figureHandle, ...
% %                     'precommands', precommands,...
% %                     'postcommands', postcommands,...
% %                     'options', {plotOpt}...
% %                     );
%             end
        end
        % This is the position at timestep
        this.treps(i).state.draw(  'axis', axisHandle, ...
            'figure',figureHandle, ...
            'precommands', precommands,...
            'postcommands', postcommands,...
            'options', {plotOpt}...
            );
        loc = this.treps(i).state.getstate({'x','y','z'});
      %  text( loc(1), loc(2), loc(3), num2str(this.ID) );
    end
end




if nargout>=1
     varargout{1} = axisHandle;
end
if nargout>=2
     varargout{2} = figureHandle;
end
