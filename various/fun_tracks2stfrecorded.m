function [stfcfglist, varargout] = getstfrecordedcfg( this )


numplats = length( sim.platforms ); % Number of platforms

stfcfg = stf_recordedcfg;

stfcfglist = stfcfg;
stfcfglist = stfcfglist([]);

stflist = stf_recorded;
stflist = stflist([]);

for cnt=1:length( uids )
   

    platformID = uids(cnt);
    ind = find( platformID == pids(sind) );
    
    rectrack = treport;
    rectrack = rectrack([]);
    
    for i=1:length(ind)
        
        mind = sind( ind(i) ); % Measurement indice is this
        
        trep = treport;
        tstate = kstate;
        tstate = tstate.setstatelabels({'x','y'});
        tstate = tstate.substate( [ x_enu( mind ) , y_enu( mind ) ]' );
        tstate.catstate;
        trep.state = tstate;
        
        trep.time = stime( ind(i) );
        rectrack(i) = trep;
        
    end
    stfcfg.rectrack = rectrack;
    stfcfglist(end+1) = stfcfg;
    
    stfobj = stf_recorded(stfcfg);
    stflist(end+1) = stfobj;
end

if nargout>=2
    varargout{1} = stime;
end
if nargout>=3
    varargout{2} = stflist;
end

    