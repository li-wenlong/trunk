function varargout = translate( splatformshadow, varargin )

trvector = zeros( 2, 1 );
alpha_ = 0;
stepcnt = 1;

nvarargin = length(varargin);
argnum = 1;
while argnum<=nvarargin
    if isa( varargin{argnum} , 'char')
        switch lower(varargin{argnum})
            case {'centre','center'}
                rotcenter =  varargin{argnum+1};
                argnum = argnum + 1;
                
            case {'translate'}
                trvector =  varargin{argnum+1};
                argnum = argnum + 1;
             case {'alpha'}
                alpha_ =  varargin{argnum+1};
                argnum = argnum + 1; 
                case {'step'}
                stepcnt =  varargin{argnum+1};
                argnum = argnum + 1;  
            otherwise
                error('Wrong input string');
        end
    elseif isa( varargin{argnum} , 'numeric')
        
    end
    argnum = argnum + 1;
end

deltax = trvector(1);
deltay = trvector(2);
deltapsi = alpha_;


stateobj = splatformshadow.track.treps(stepcnt).state;
statelabels = stateobj.getstatelabels;
stateobj.setstatelabels({'x','y'});
statevec = stateobj.getstate;
stateobj.substate( statevec + [deltax, deltay]' );
stateobj.setstatelabels( statelabels );

splatformshadow.track.treps(stepcnt).state = stateobj;
    
    
ssensorobj = splatformshadow.sensors{1};

pstateobj = ssensorobj.srbuffer(stepcnt).pstate;
statelabels = pstateobj.getstatelabels;
pstateobj.setstatelabels({'x','y'})
statevec = pstateobj.getstate;
pstateobj.substate( statevec + [deltax, deltay]' );
pstateobj.setstatelabels( statelabels );
    
ssensorobj.srbuffer(stepcnt).pstate = pstateobj;

sstateobj = ssensorobj.srbuffer(stepcnt).sstate;
sstatelabels = sstateobj.getstatelabels;
sstateobj.setstatelabels({ 'psi'});
statevec = sstateobj.getstate;
sstateobj.substate( statevec +  [deltapsi]' );
sstateobj.setstatelabels(sstatelabels );

ssensorobj.srbuffer(stepcnt).sstate = sstateobj;

splatformshadow.sensors{1} = ssensorobj;


if nargout == 0
    if ~isempty( inputname(1) )
        assignin('caller',inputname(1),splatformshadow);
    else
        error('Could not overwrite the instance; make sure that the argument is not in an array!');
    end
else
    varargout{1} = splatformshadow;
end
