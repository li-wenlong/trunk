
asvfiles = findiru(cd,{'.asv'},'file');

while ~isempty(asvfiles)
    myfile = asvfiles{1};
    if ~exist(myfile)
        asvfiles = asvfiles(2:end);
        continue;
    end
    
    if ~isempty(findstr(myfile,'.svn'))
        disp(sprintf('Not deleting %s',myfile));
        asvfiles = asvfiles(2:end);
        continue;
    end
    disp(sprintf('Press any key to delete %s', myfile))
    pause;
    recycle('off');
    delete(myfile);
    asvfiles = asvfiles(2:end);
end

% Linux auto save files
asvfiles = findiru(cd,{'.m~'},'file');

while ~isempty(asvfiles)
    myfile = asvfiles{1};
    if ~exist(myfile)
        asvfiles = asvfiles(2:end);
        continue;
    end
    
    if ~isempty(findstr(myfile,'.svn'))
        disp(sprintf('Not deleting %s',myfile));
        asvfiles = asvfiles(2:end);
        continue;
    end
    disp(sprintf('Press any key to delete %s', myfile))
    pause;
    recycle('off');
    delete(myfile);
    asvfiles = asvfiles(2:end);
end
