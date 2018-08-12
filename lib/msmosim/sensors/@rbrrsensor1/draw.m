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
isvelvect = 0;
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
        elseif strcmp( lower( varargin{cnt} ), 'rangerate' )
            isvelvect = varargin{cnt+1};
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
        
        tvelS = [ cos(z.bearing)*z.rangerate, sin(z.bearing)*z.rangerate, 0 ]';
        tvelE = R_BE'*R_SB'*tvelS + pstate.velearth + R_BE'*sstate.velearth;
        
        plotOpts = plotOpt{1};
        
        if isonlyx
            eval(['plot( i, tlocE(1),', plotOpts ,');'] )
        elseif isonlyy
            eval(['plot( i, tlocE(2),', plotOpts ,');'] )
        elseif isonlyz
            eval(['plot( i, tlocE(3),', plotOpts ,');'] )
        else
            if ~isoveridecolor
                if ~isempty(srep.given)
                    if srep.given(j) == 0
                        plotOpts = [plotOpts, ',''Color'',''k'''];
                    end
                end
            end
            eval(['plot3(tlocE(1), tlocE(2), tlocE(3),', plotOpts ,');'] )
            if isvelvect
                % Draw the velocity vector
                arrowHeadX = [0 0 1]';
                arrowHeadY = [-0.125,0.125,0]';
                arrowHeadC = [0 0 1];
                
                v = [tvelE(1),tvelE(2)]';
                normV = norm(v);
                argV = atan2(v(2),v(1));
                
                arrowHeadX = arrowHeadX*normV/6;
                arrowHeadY = arrowHeadY*normV/6;
                
                % Shift the arrow head
                arrowHeadX = arrowHeadX+normV-max(arrowHeadX);
                
                % Rotate the arrow head
                alpha = argV;
                rotM = [cos(alpha), -sin(alpha);sin(alpha), cos(alpha)];
                arrowHeadR = rotM*[arrowHeadX';arrowHeadY'] +...
                    [tlocE(1),tlocE(1),tlocE(1);tlocE(2),tlocE(2),tlocE(2)];
                
                eval(['plot([tlocE(1),tlocE(1)+tvelE(1)], [ tlocE(2), tlocE(2)+tvelE(2) ]);'] );
                
                patch(arrowHeadR(1,:)',arrowHeadR(2,:)', arrowHeadC,'EdgeColor', arrowHeadC);
            end
        end
    end
    
end
hold off
