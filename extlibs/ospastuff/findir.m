function fullPath = findir( workDir, dName )
% function fullPath = findir( workDir, dName )
% returns the fullpath of the directory dName which is nearest to the
% workDir in the directory tree
%
% Murat Uney
%
% For now, only it searches the immediate children of the ancestors, an
% appropriate version will be implemented later

if nargin ~= 2
    error('Insufficient number of inputs!');
else
    if ~isa( workDir, 'char') || ~isa( dName, 'char')
        error('The inputs must be char array, i.e. strings !');
    end
end
        
fullPath = '';

sepChar = filesep;
sepChars = find( workDir==sepChar );
sepChars = [sepChars, length(workDir)];

checkDir = workDir;
crrntDir = dir(checkDir);
for dirCnt =1:length( crrntDir )
    if crrntDir(dirCnt).isdir == 1
        if strcmp( lower(crrntDir(dirCnt).name),lower(dName) )
            fullPath = [workDir, sepChar, dName ] ;
            return;
        end
    end
end

for ancCnt = length(sepChars):-1:1
    checkDir = workDir(1:sepChars(ancCnt));
    crrntDir = dir(checkDir);
    for dirCnt =1:length( crrntDir )
        if crrntDir(dirCnt).isdir == 1
            if strcmp( lower(crrntDir(dirCnt).name),lower(dName) )
                fullPath = [workDir(1:sepChars(ancCnt)), dName ] ;
                return;
            end
        end
    end
end