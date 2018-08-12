function varargout = show( this, varargin )

figureHandle = [];
axisHandle = [];
postcommands = '';
precommands = '';
timestep = 1;

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

for i=1:length(this.srbuffer)
    % Get the sensor report
    srep = this.srbuffer(i);
    if timestep~=srep.time
        continue;
    end

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
        % Get an observation
        z = srep.Z(j);
        tlocS = [ cos(z.bearing)*z.range, sin(z.bearing)*z.range, 0 ]';
        tlocE = R_BE'*R_SB'*tlocS + pstate.location + R_BE'*sstate.location;
        
              
        if isonlyx
            eval(['plot( i, tlocE(1),', plotOpt ,');'] )
        elseif isonlyy
            eval(['plot( i, tlocE(2),', plotOpt ,');'] )
        elseif isonlyz
            eval(['plot( i, tlocE(3),', plotOpt ,');'] )
        else
            if ~isoveridecolor
            if srep.given(j) == 0
              plotOpt = [plotOpt, ',''Color'',''k'''];
            end
            end
            eval(['plot3(tlocE(1), tlocE(2), tlocE(3),', plotOpt ,');'] )
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
