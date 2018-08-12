function fullfilepaths = findiru( workDir, dNames, varargin )
% function fullfilepaths = findiru( workDir, dNames )
% returns the fullpath of the directories that contains the string 
% fragments in the cell array dNames under the children directories
%
% Murat Uney
%

if nargin < 2
    error('Insufficient number of inputs!');
else
    if ~isa( workDir, 'char') || ~isa( dNames, 'cell')
        error('The first argument is a char array and the second is a cell array of strings!');
    end
    dNames = dNames(:);
    for i=1:length(dNames)
        if ~isa(dNames{i},'char')
            error('The cell entries of the second argument are strings!');
        end
        dNames{i} = lower(dNames{i});
    end
    cntrl = 0;
    ematchcntrl = 0;
    if nargin>=3
        for i=1:length(varargin)
            if isa(varargin{i},'char')
                switch lower(varargin{i})
                    case 'dir',
                        cntrl =  1;
                    case 'file',
                        cntrl = 2;
                    case 'exact',
                        ematchcntrl = 1;
                    otherwise,
                        error('Unknown option');
                end
            else
                error('The option should be a char!')
            end
        end
    end
end
        
fullfilepaths = {};

sepChar = filesep;
sepChars = find( workDir==sepChar );
sepChars = [sepChars, length(workDir)];

checkDir = workDir;
crrntDir = dir(checkDir);
for dirCnt=1:length( crrntDir )
    if strcmp( crrntDir(dirCnt).name,'.') | strcmp( crrntDir(dirCnt).name,'..')
        continue;
    end
    fullpathname =  [workDir, sepChar, crrntDir(dirCnt).name ] ;
    if crrntDir(dirCnt).isdir == 1
        fullpathsbelow = findiru( fullpathname, dNames, varargin{:}   );
        fullfilepaths(end+1:end+length(fullpathsbelow)) = fullpathsbelow;
    end
    if ematchcntrl==0
        if isintemplate( lower(crrntDir(dirCnt).name), dNames )
            chk1 = cntrl == 0;
            chk2 = cntrl == 1 & crrntDir(dirCnt).isdir == 1;
            chk3 = cntrl == 2 & crrntDir(dirCnt).isdir ~= 1;
            if chk1 | chk2 | chk3
                fullfilepaths{end+1} = fullpathname;
            end
        end
    else
        % Exact match
        if strcmp( lower(crrntDir(dirCnt).name), dNames{1} )
            fullfilepaths{end+1} = fullpathname;

        end

    end
end


function l = isintemplate( name, dNames )
l = 0;

pnt = {};
for i = 1:length(dNames)
    pnt{i} = strfind(name, dNames{i} );
    if isempty( pnt{i} )
        return;
    end
    
end


fpnt = pnt{1};
for i=1:length(fpnt)
    lastcheck = fpnt(i);
    lastcheckdepth = 1;
    if lastcheckdepth == length( pnt )
        l = 1;
        return;
    end
    for j=2:length( pnt )
        for k=1:length( pnt{j})
            if pnt{j}(k)>lastcheck
                lastcheck = pnt{j}(k);
                lastcheckdepth = j;
                if lastcheckdepth == length( pnt )
                    l = 1;
                    return;
                end
                break;
            end
        end
    end
end
    
    
    

