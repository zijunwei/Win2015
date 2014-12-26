function [cameraNo, sessionNo, recordNo, lightNo, subjectID] = ...
    ml_mpieName2Prop(fileName)
% Get properties of an image file or landmark file of MPIE database. 
% Inputs:
%   fileName: Name of the PNG or landmark file.
% Outputs:
%   Properties of the image or landmark.
% Other Notes: See related function: ml_mpieProp2Name.
% By Minh Hoai Nguyen
% Date: 2 June 07

name = ml_full2shortName(fileName);
subjectID = str2double(name(1:3));
sessionNo = str2double(name(5:6));
recordNo = str2double(name(8:9));
cameraNo = str2double(name(11:13));
lightNo = str2double(name(15:16));
