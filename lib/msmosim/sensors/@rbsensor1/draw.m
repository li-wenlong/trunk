function varargout = draw(this, varargin )


% plotOpt = {{'b.'},{'r.'},{'g.'},{'m.'},{'y.'},...
%     {'c.'},{'k.'},{'bo'},{'ro'},{'go'},...
%     {'mo'},{'yo'},{'co'},{'ko'},{'bx'},...
%     {'rx'},{'gx'},{'mx'},{'yx'},{'cx'},...
%     {'kx'},{'bp'},{'rp'},{'gp'},{'mp'},...
%     {'yp'},{'cp'},{'kp'}};

plotOpt = {'''b.''','''r.''','''g.''','''m.''','''y.''',...
    '''c.''','''k.''','''bo''','''ro''','''go''',...
    '''mo''','''yo''','''co''','''ko''','''bx''',...
    '''rx''','''gx''','''mx''','''yx''','''cx''',...
    '''kx''','''bp''','''rp''','''gp''','''mp''',...
    '''yp''','''cp''','''kp'''};

isonlyx = 0;
isonlyy = 0;
isonlyz = 0;
isoveridecolor = 0;

figureHandle = [];
axisHandle = [];
for cnt=1:2:length(varargin)
    if ischar( varargin{cnt})&& cnt +1 <= length(varargin )
        if strcmp( lower( varargin{cnt} ), 'axis' )
            axisHandle = varargin{cnt+1};
            isAxisHandlesReceived = 1;
        elseif strcmp( lower( varargin{cnt} ), 'figure' )
            figureHandle =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'options' )
            plotOpt  = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyx' )
            isonlyx =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyy' )
            isonlyy =  varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'onlyz' )
            isonlyz = varargin{cnt+1};
        elseif strcmp( lower( varargin{cnt} ), 'overidecolor' )
            isoveridecolor = varargin{cnt+1};
            
        else
            warning(sprintf('Unidentified token: %s !', varargin{cnt}));
        end
    else
        error('Wrong input string');
    end
end

for i=1:length( plotOpt )
    plotOpt{i} = [ plotOpt{i},',''Marker'',''x'''];
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end

axes(axisHandle);
hold on
grid on

for i=1:length(this.srbuffer)
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
        % Get an observation
        z = srep.Z(j);
        tlocS = [ cos(z.bearing)*z.range, sin(z.bearing)*z.range, 0 ]';
        tlocE = R_BE'*R_SB'*tlocS + pstate.location + R_BE'*sstate.location;
        
        plotOpts = plotOpt{1};
        
        if isonlyx
            eval(['plot( i, tlocE(1),', plotOpts ,');'] )
        elseif isonlyy
            eval(['plot( i, tlocE(2),', plotOpts ,');'] )
        elseif isonlyz
            eval(['plot( i, tlocE(3),', plotOpts ,');'] )
        else
            if ~isoveridecolor
            if srep.given(j) == 0
              plotOpts = [plotOpts, ',''Color'',''k'''];
            end
            end
            eval(['plot3(tlocE(1), tlocE(2), tlocE(3),', plotOpts ,');'] )
        end
    end
    
end
hold off
