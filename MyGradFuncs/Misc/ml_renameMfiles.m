function ml_renameMfiles(srcDir, oldPrefix, newPrefix)
% Rename the prefixes of .m files in a directory.
% This also renames the references inside the functions 
% Example: ml_renameMfiles('./', 'M_', 'MUB_');
%          ml_renameMfiles('./', 'm_', 'mub_'); 
% By: Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Created: 13-Jan-2014
% Last modified: 13-Jan-2014


fls = dir(sprintf('%s/%s*.m', srcDir, oldPrefix));


[oldNames, newNames] = deal(cell(1, length(fls)));
for i=1:length(fls)
    oldName = fls(i).name;
    oldName = oldName(1:end-2);
    oldNames{i} = oldName;    
    newName = sprintf('%s%s', newPrefix, oldName(length(oldPrefix)+1:end)); 
    newNames{i} = newName;
end;

% because fls are sorted using lexical order, renaming should start from the end of the list
% e.g, M_A2 should be renamed before M_A because all M_A2 matches M_A
for i=length(oldNames):-1:1
    cmd = sprintf('grep -l "%s" %s/*.m | xargs sed -i sedbak "s/%s/%s/g"', ...
        oldNames{i}, srcDir, oldNames{i}, newNames{i});
    fprintf('%s\n', cmd);    
    system(cmd);
    
    cmd = sprintf('mv "%s/%s.m" "%s/%s.m"', srcDir, oldNames{i}, srcDir, newNames{i});
    fprintf('%s\n', cmd);
    system(cmd);    
end;

cmd = sprintf('rm %s/*.msedbak', srcDir);
fprintf('%s\n', cmd);
system(cmd);

