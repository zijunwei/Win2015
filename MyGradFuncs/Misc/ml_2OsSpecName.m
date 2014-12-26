function newName = ml_2OsSpecName(oldName, osType)
% m_2OsSpecName: convert file name to conform with OS specific standard.
% Inputs:
%   oldName: the name we want to convert
%   osType: type of OS, it could be either 'linux' or 'windows'
% Outputs:
%   newName: new name that conforms to the OS specific standard
% By Minh Hoai Nguyen
% Date: 16 March 07

if strcmp(osType, 'linux')
    newName = strrep(oldName, '\', '/');
elseif strcmp(osType, 'windows')
    newName = strrep(oldName, '/', '\');
end