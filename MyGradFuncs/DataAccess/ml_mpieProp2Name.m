function imName = ml_mpieProp2Name(osType, ...
    cameraNo, sessionNo, recordNo, lightNo, subjectID)
% Get the full name of image file that have the settings matched with the 
% params specified.
% Inputs:
%   osType: type of operating system, either 'linux' or 'win'
%   cameraNo: the ID of camera. 
%   sessionNo: there are 4 sessions 1,2,3,4.
%   recordNo: recording number in each session, images taken in same
%       session with same recording number are of same facial expression.
%   lightNo: illumination of images required.
%   subjectID: the ID of the the subject.
% Other Notes:
%   See related function: ml_mpieName2Prop
% Outputs:
%   imName: the name of the image.
% By Minh Hoai Nguyen
% Date: 2 June 07

    
if strcmp(osType, 'linux')
    imDir = '/cv/data/face/multipi';
else
    imDir = 'Z:\DataBases\multipie\images';
end;

str = num2str(cameraNo);
cameraDir = sprintf('%.2d_%s', str2num(str(1:end-1)), str(end));

    
name = sprintf('%.3d_%.2d_%.2d_%.3d_%.2d', ...
    subjectID, sessionNo, recordNo, cameraNo, lightNo);
imPath = sprintf('%s/session%.2d/multipie_png/%.3d/%.2d/%s/', ...
    imDir, sessionNo, subjectID, recordNo, cameraDir);
imName = [imPath, name, '.png'];
