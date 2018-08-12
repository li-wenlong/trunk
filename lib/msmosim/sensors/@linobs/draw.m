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

    plocE = pstate.getstate({'x','y','z'});
    angBE = pstate.getstate({'psi','theta','phi'});
    R_BE = dcm(angBE);

    slocB = sstate.getstate({'x','y','z'});
    angSB = sstate.getstate({'psi','theta','phi'});
    R_SB = dcm( angSB );

    ploc = pstate.location;
    sloc = sstate.location;
    
    T = R_SB*R_BE; % Earth to Sensor
    T_E = T'; % Sensor to Earth
    H = this.linTrans;
   
    for j = 1:size(srep.Z,2)
        % Get an observation
        z = srep.Z(:,j).Z;
        x = inv(H'*H)*H'*z;
        
        x = [x;zeros( length(sloc) - length(x), 1 )];
        
        x_ = (ploc + R_BE'*sloc) + T_E*( x );
        
        plotOpts = plotOpt{1};
        if srep.given(j) == 0
            plotOpts = [plotOpts, ',''Color'',''k'''];
        end
        axis(axisHandle);
        eval( ['plot( x_(1), x_(2) ,', plotOpts,')']);
        
    end
    
end
hold off
