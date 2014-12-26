function [shortName, fullName, fileName] = ml_getFuncName()
% Get the name of the function running this code
% By: Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Created: 01-Jun-2014
% Last modified: 01-Jun-2014

A = dbstack(1);
if isempty(A)
    fullName  = '';
    shortName = '';    
    fileName  = '';
else
    fullName = A.name;
    idx = find(fullName == '.');
    if ~isempty(idx)
        shortName = fullName(idx+1:end);
    else
        shortName = fullName;
    end;
    fileName = A.file;
end