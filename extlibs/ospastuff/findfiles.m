function files = findfiles( workDir, fName )
% function files = findfiles( workDir, fName )
% returns the fullpath of the files starting with fName which is nearest to the
% workDir in the directory tree
%
% Murat Uney
%
% For now, it only searches the immediate children, an
% appropriate version will be implemented later

if nargin ~= 2
    error('Insufficient number of inputs!');
else
    if ~isa( workDir, 'char') || ~isa( fName, 'char')
        error('The inputs must be char array, i.e. strings !');
    end
end
        
fullpath = '';
files = {};

sepChar = filesep;
sepChars = find( workDir==sepChar );
sepChars = [sepChars, length(workDir)];

checkDir = workDir;
crrntDir = dir(checkDir);
decendants = [];
for fileCnt =1:length( crrntDir )
    if crrntDir(fileCnt).isdir == 0
        % This is a file
        if strfind( lower(crrntDir(fileCnt).name),lower(fName) )
            fullPath = [workDir, sepChar, crrntDir(fileCnt).name ] ;
            files{end+1} = fullPath;
        end
    elseif crrntDir(fileCnt).isdir == 1 &&  ~strcmp( crrntDir(fileCnt).name,'.' ) && ~strcmp( crrntDir(fileCnt).name,'..' )
        decendants(end+1) = fileCnt;        
    end
end

for decCnt = 1:length(decendants)
    files = [files, findfiles( [workDir,sepChar,crrntDir(decendants(decCnt)).name], fName )];
end