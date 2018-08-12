function repfiles(src, destname , varargin)
% REPFILES replicates the source files or directories under the specified
% directory destname
%
% Murat

f= 0;
if nargin>=3
    if strcmp(varargin{1}(1), 'f');
        f = 1;
    end
end


sepChar = filesep;
workDir = cd;



for i=1:length(src)
    ind = findstr(src{i},workDir);
    if ~isempty(ind)
        ex = exist( src{i} );
        if ex
            % This entity exists
            destf = [src{i}(1:ind-1),workDir,sepChar,destname,src{i}(length(workDir)+1:end)];
            dex = exist(destf);       
            if dex
                if f == 1
                    switch dex
                        case 7,
                            % This is a directory
                            rmdir(destf);
                        otherwise
                            % This is a file
                            delete(destf);
                    end
                    
                else
                    continue;
                end
            end
            % Build the directory structure
            sepChars = find( destf==sepChar );
            sepChars = sepChars( find(sepChars> length([workDir])+1 ) );
            for j=1:length(sepChars)
                if ~exist( destf(1:sepChars(j)-1) )
                    mkdir([destf(1:sepChars(j)-1)]);
                end
            end
                
            copyfile(src{i}, destf);
        end  
    end
end
