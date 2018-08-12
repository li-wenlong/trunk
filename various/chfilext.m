function inp = chfilext( inp, extstr )
% function inp = chfilext( inp, extstr )
% changes the extension of the file the name of which is stored in the
% string inp. The new extension is the string extstr. 
% For multiple files, inp is a cell array of strings.
% See also getfname

% Murat Uney 




if iscell( inp )
    for i=1:length( inp )
        inp{i} = chfilext( inp{i}, extstr );
    end
elseif ischar( inp )
     % Find the mat file name
    ldot = findstr( inp, '.' );
    if isempty(ldot)
        inp = [inp,'.'];
        ldot = length(inp) + 1;
    end
    inp = [ inp(1:ldot(end)), extstr ];
end
    