function [stfcfglist, varargout] = getstfrecordedcfgs( this )


numplats = length( this.platforms ); % Number of platforms

stfcfg = stf_recordedcfg;

stfcfglist = stfcfg;
stfcfglist = stfcfglist([]);

stflist = stf_recorded;
stflist = stflist([]);

stime = {};
for cnt=1:numplats
    rectrack = treport;
    rectrack = rectrack([]);
    
    stfcfg.rectrack = this.platforms{cnt}.track.treps ;
    stfcfglist(end+1) = stfcfg;
    
    stfobj = stf_recorded(stfcfg);
    stflist(end+1) = stfobj;
    
    %stime = union( stime, cell2mat( {this.platforms{cnt}.track.treps.time} ) );
    stime{cnt} = cell2mat( {this.platforms{cnt}.track.treps.time} ) ;
    stime{cnt}(1) = stime{cnt}(1) - this.deltat;
end

if nargout>=2
    varargout{1} = stime;
end

if nargout>=3
    varargout{1} = ftime;
end


if nargout>=4
    varargout{2} = stflist;
end

    