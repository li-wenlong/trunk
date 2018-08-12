function varargout = draw(this, varargin )


% plotOpt = {{'b-'},{'r-'},{'g-'},{'m-'},{'y-'},...
%     {'c.'},{'k.'},{'bo'},{'ro'},{'go'},...
%     {'mo'},{'yo'},{'co'},{'ko'},{'bx'},...
%     {'rx'},{'gx'},{'mx'},{'yx'},{'cx'},...
%     {'kx'},{'bp'},{'rp'},{'gp'},{'mp'},...
%     {'yp'},{'cp'},{'kp'}};


LineStyleOpts = {'''-''','''--''','''-.''',''':'''};
plotOpt = {'''b-''','''r-''','''g-''','''m-''','''y-''',...
    '''c-''','''k-''','''b-.''','''r-.''','''g-.''',...
    '''m-.''','''y-.''','''c-.''','''k-.''','''b--''',...
    '''r--''','''g--''','''m--''','''y--''','''c--''',...
    '''k--''','''b:''','''r:''','''g:''','''m:''',...
    '''y:''','''c:''','''k:'''};

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
    plotOpt{i} = [ plotOpt{i},',''Marker'',''none'',''LineStyle'',',LineStyleOpts{ mod(i-1,4) + 1 }];
end

if isempty(axisHandle)
    if isempty(figureHandle)
        figureHandle = figure;
    end
    axisHandle = gca;
end


if length(this)>1
    this(2:end).draw('axis', axisHandle, 'options' , plotOpt(2:end), 'onlyx', isonlyx, 'onlyy', isonlyy, ...
        'onlyz', isonlyz, 'overidecolor', isoveridecolor);
    this = this(1);
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
        tlocSmin = [ cos(z.bearing)*this.minrange, sin(z.bearing)*this.minrange, 0 ]';
        tlocSmax = [ cos(z.bearing)*this.maxrange, sin(z.bearing)*this.maxrange, 0 ]';

        tlocEmin = R_BE'*R_SB'*tlocSmin + pstate.location + R_BE'*sstate.location;
        tlocEmax = R_BE'*R_SB'*tlocSmax + pstate.location + R_BE'*sstate.location;
        
        slocE = pstate.location + R_BE'*sstate.location;

        plotOpts = plotOpt{1};
        
        if isonlyx
            eval(['plot( [i,i], [tlocEmin(1), tlocEmax(1)],', plotOpts ,');'] )
        elseif isonlyy
            eval(['plot( [i,i], [tlocEmin(2), tlocEmax(2)],', plotOpts ,');'] )
        elseif isonlyz
            eval(['plot( [i,i], [tlocEmin(3), tlocEmax(3)],', plotOpts ,');'] )
        else
            if ~isoveridecolor
                if ~isempty(srep.given)
                    if srep.given(j) == 0
                        plotOpts = [plotOpts, ',''Color'',''k'''];
                    end
                end
            end
            eval(['plot3([tlocEmin(1), tlocEmax(1)]'', [ tlocEmin(2), tlocEmax(2)]'',[tlocEmin(3), tlocEmax(3)]'',', plotOpts ,');'] )
            eval(['plot3(slocE(1), slocE(2), slocE(3)'',', plotOpts ,',''Marker'',''o'',''Linestyle'',''none'');'] )

          
        end
    end
    
end
hold off
