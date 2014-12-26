function [mask, XI, YI] = ml_mpieFaceReg(imSz, lmPts, regionType)
% function [mask, XI, YI] = ml_mpieFaceReg(imSz, lmPts, regionType)
% This function extract the face region of images in MPIE database.
% Inputs:
%   imSz: the [imH, imW] size of the image.
%   lmPts: the coordinates of 68 landmarks. This is a 68*2 matrix.
%   regionType: the type of regions that we want to extract. Possible
%       values: could be: 'face', 'leftEye', 'rightEye', 'nose', 
%       'outerLip', 'innerLip'.
% Outputs:
%   mask: The binary mask of the region of interest.
%   XI, YI: the X and Y indexes of region of interest.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 11 May 07


im = zeros(imSz);

if strcmp(regionType, 'face')
    faceBnd = [lmPts(1:17,:); lmPts(27:-1:18,:); lmPts(1,:)];
    mask = roipoly(im, faceBnd(:,1), faceBnd(:,2));
elseif strcmp(regionType, 'leftEye')
    lEyeBnd = [lmPts(37:42,:); lmPts(37,:)];
    mask = roipoly(im, lEyeBnd(:,1), lEyeBnd(:,2));
elseif strcmp(regionType, 'rightEye')
    rEyeBnd = [lmPts(43:48,:); lmPts(43,:)];
    mask = roipoly(im, rEyeBnd(:,1), rEyeBnd(:,2));
elseif strcmp(regionType, 'nose')
    noseBnd = [lmPts(28,:); lmPts(32:36,:); lmPts(28,:)];
    mask = roipoly(im, noseBnd(:,1), noseBnd(:,2));
elseif strcmp(regionType, 'outerLip')
    outLipBnd = [lmPts(49:60,:); lmPts(49,:)];
    mask = roipoly(im, outLipBnd(:,1), outLipBnd(:,2));
elseif strcmp(regionType, 'innerLip')
    inLipBnd = [lmPts(61:68,:); lmPts(61,:)];
    mask = roipoly(im, inLipBnd(:,1), inLipBnd(:,2));
end;

[YI, XI] = ind2sub(imSz, find(mask));
