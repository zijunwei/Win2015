function [I, J] = ml_cmpAppNJacobian_helper(im, imDx, imDy, shpParam, appXYIs, mode)
% function [I, J] = ml_cmpAppNJacobian_helper(im, imDx, imDy, shpParam, appXYIs, mode)
% Compute Appearance and Jacobian of an image w.r.t to affine shape parameters.
% This works not only for MPIE images but also other type of images.
% Inputs:
%   im: the image
%   shpParam: the shape parameters, this is a column vector of size 6*1 for affine transformation.
%       If we denote A = shpParam, the affine transformation matrix is:
%       M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];
%   appXYIs: This is a m*2 matrix. appXYIs(:,1), appXYIs(:,2) are 
%       X,Y coordinates of pixels in the patch being considered. 
%   mode: valid options are: 'Jacobian', 'App', 'App_Jacobian'. This to set whether
%       this function should compute the Appearance and Jacobian for the corresponding
%       shape params. One should use the correct option because the computational cost 
%       of this function depends on this option.
% Outputs:
%   I: the appearance w.r.t shape params. This is m*1 column vector.
%       If the mode = 'Jacobian' only, I is [].
%   J: the Jacobian of image appearance with respect to shape parameters.
%       This is a m*6 maxtrix. However, if mode = 'App', J is returned empty [].
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 24 Jan 2008.

[imH, imW] = size(im);    

XGrid = [1 1 imH]; %Meshgrid of qqinterp2
YGrid = [1 1 imW];

XI = appXYIs(:,1);
YI = appXYIs(:,2);

% Affine transformation matrix.
A = shpParam;
M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];   

%XI and YI after non-rigid and affine transformation.
curXYI = [XI, YI, ones(length(XI),1)]*M';               

if strcmp(mode, 'App_Jacobian')
    [I, winDx, winDy]  = qqinterp2(XGrid,YGrid, curXYI(:,1), curXYI(:,2), im, imDx, imDy);
elseif strcmp(mode, 'App')
    I = qqinterp2(XGrid, YGrid, curXYI(:,1), curXYI(:,2), im);
    J = [];
elseif strcmp(mode, 'Jacobian')
    [winDx, winDy]  = qqinterp2(XGrid,YGrid, ...
        curXYI(:,1), curXYI(:,2), imDx, imDy);
    I = [];
else
    error('ml_cmpAppNJacobian_helper.m: Unknown option for mode. Valid options: App, Jacobian, App_Jacobian');
end;

if strcmp(mode, 'App_Jacobian') || strcmp(mode, 'Jacobian')
    %Jacobian of affine motion.
    J = [winDx.*XI, winDx.*YI, winDx, winDy.*XI, winDy.*YI, winDy];
end;

