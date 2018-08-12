function varargout = show( this, varargin )

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
timestep = 1;
stepcnt = 1;
istimestep = 0;
isstep = 0;

plotOpt = '''Marker'',''x'',''LineStyle'',''None'',''Color'',[0 0 1]';

isonlyx = 0;
isonlyy = 0;
isonlyz = 0;
isoveridecolor = 0;

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
                     plotOpt = [plotOpt, ',', varargin{argnum+1}];
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
                     istimestep = 1;
                     argnum = argnum + 1;
                 end
             case {'step'}
                 if argnum + 1 <= nvarargin
                     stepcnt = varargin{argnum+1};
                     isstep = 1;
                     argnum = argnum + 1;
                 end
             
             case {'onlyx'}
                 if argnum + 1 <= nvarargin
                     isonlyx = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'onlyy'}
                 if argnum + 1 <= nvarargin
                     isonlyy = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'onlyz'}
                 if argnum + 1 <= nvarargin
                     isonlyz = varargin{argnum+1};
                     argnum = argnum + 1;
                 end
             case {'overidecolor'}
                 if argnum + 1 <= nvarargin
                     isoveridecolor = varargin{argnum+1};
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
%%%%%%%%%%%%%%%%%%%
axes(axisHandle);
if ~isempty(precommands)
     eval( precommands );
end
hold on
grid on


if isstep
    timestep = this.srbuffer(stepcnt).time;
end

timestamps = cell2mat({this.srbuffer(:).time});
ind = find( timestep == timestamps );
    



if ~isempty( ind )
    i = ind(1);
    % Get the sensor report
    srep = this.srbuffer(i);
    
    pstate = srep.pstate;
    sstate = srep.sstate;

    if this.insensorframe == 0
        plocE = pstate.getstate({'x','y','z'});
        angBE = pstate.getstate({'psi','theta','phi'});
        R_BE = dcm(angBE);
        
        slocB = sstate.getstate({'x','y','z'});
        angSB = sstate.getstate({'psi','theta','phi'});
        R_SB = dcm( angSB );
    else
        % The incoming particles locationE_ are already in sensor coordinate
        % system
        plocE = [0 0 0]';
        angBE = [0 0 0]';
        R_BE = eye(3);
        
        slocB = [0 0 0]';
        angSB = [0 0 0]';
        R_SB = eye(3);
    end

    for j = 1:length(srep.Z)
        z = srep.Z(j); % This is an mlinmeas object with the field Z;
        if isempty(z.Z)
            continue; % No observation
        end
        %tlocS = [ cos(z.bearing)*z.range, sin(z.bearing)*z.range, 0 ]';
        tlocsS = [z.Z; zeros(1, size( z.Z, 2) ) ];
        tlocsE = R_BE'*R_SB'*tlocsS + repmat( pstate.location + R_BE'*sstate.location,1, size(tlocsS,2) );
        
        
        if isonlyx
            eval(['plot( i*ones(size( tlocsE(1,:) ) ), tlocsE(1,:),', plotOpt ,');'] )
        elseif isonlyy
            eval(['plot( i*ones(size( tlocsE(2,:) ) ), tlocsE(2,:),', plotOpt ,');'] )
        elseif isonlyz
            eval(['plot( i*ones(size( tlocsE(3,:) ) ), tlocsE(3,:),', plotOpt ,');'] )
        else
            if ~isoveridecolor && ~isempty( srep.given )
                if srep.given(j) == 0
                    plotOpt = [plotOpt, ',''Color'',''k'''];
                end
            end
            if ~iscell(plotOpt)
                eval(['plot3(tlocsE(1,:), tlocsE(2,:), tlocsE(3,:),', plotOpt ,');'] );
            else
                eval(['plot3(tlocsE(1,:), tlocsE(2,:), tlocsE(3,:),', plotOpt{min(j,length(plotOpt))} ,');'] );
            end
        end
    end
    
end
if ~isempty(postcommands)
    eval(postcommands );
end
hold off




%%%%%%%%%%%%%%%%%%%%
if nargout>=1
     varargout{1} = axisHandle;
end
if nargout>=2
     varargout{2} = figureHandle;
end
