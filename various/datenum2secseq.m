function ss = datenum2secseq( na )
% s = datenum2secseq( na ) converts a date num. array to a time sequence
% array in seconds starting from 1.
%
% Murat Uney

if ~isnumeric( na )
    error('The input should be a numeric array!');
end

if size(na,2)~=1
    tvec = datevec(na);
    mindate = datevec( min(na) );
else
    tvec = na;
    
    mindate = datevec( min ( datenum( na ) ));
    
    
end

ss = ( tvec(:,4)-mindate(4) )*60*60 + ( tvec(:,5)-mindate(5) )*60 + ( tvec(:,6)-mindate(6) ) +1;