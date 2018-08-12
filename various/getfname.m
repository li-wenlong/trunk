function inp = getfname( inp, varargin )
% function out = getfname( inp )
% Gets the filename from the input string of relative locations.
% For multiple files, inp is a cell array of strings.
% Ex. getfname( '/mydir/myfile.myext' ) returns myfile.myext on a unix
% system. 
% In order to input the file seperation character, use
% getfname( inp, fsep ) where fsep is '/' for unix and '\' for MS
% Win systems.

% See also chfilext

% Murat Uney

sepchar = filesep;

if ~isempty( varargin )
    for cnt=1:length(varargin)
        if ~ischar( varargin{cnt} )
            error('input argument cannot be interpreted!')
        else
            sepchar  = varargin{cnt};
        end
    end
end
        



if iscell( inp )
    for i=1:length( inp )
        inp{i} = getfname( inp{i}, varargin{:} );
    end
elseif ischar( inp )
    % Find the mat file name
    posep = findstr( inp, sepchar );
    if isempty(posep)
        posep = 0;
    end
    inp = [ inp(posep(end)+1:end) ];
    
end
    