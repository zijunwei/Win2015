function [I, J] = ml_cmpMpieAppNJacobian(im, shpParam, ptchXYIs, ShpBasis, mode)
% [I, J] = ml_cmpMpieAppNJacobian(im, shpParam, ptchXYIs, ShpBasis)
% Compute Appearance and Jacobian of w.r.t to shape parameters.
% Inputs:
%   im: the image
%   shpParam: the shape parameters, this is a column vector of size (6+k)*1.
%       The first six components are for affine motion.
%       If we denote A = shpParam, the affine transformation matrix is:
%       M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];
%       The rest of the shpParam is non-rigid shape params.
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. ptchXYIs is computed
%       by function: ml_mpieFacePtchs. Look at that function for more
%       details.
%   ShpBasis: the basis of shape variations. Each column is a basis vector.
%       Look at function ml_mpieShpPCA for more details.
%   mode: valid options are: 'Jacobian', 'App', 'App_Jacobian'. This to set whether
%       this function should compute the Appearance and Jacobian for the corresponding
%       shape params. One should use the correct option because the computational cost 
%       of this function depends on this option.
% Outputs:
%   I: the appearance w.r.t shape params. This is m*1 column vector.
%       If the mode = 'Jacobian' only, I is [].
%   J: the Jacobian of image appearance with respect to shape parameters.
%       This is a m*(6+k) maxtrix. However, if mode = 'App', J is returned empty [].
% See also: ml_cmpMpieAppNJacobian_helper.m
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 9 Oct 2007.


if strcmp(mode, 'App')
    imDx = []; imDy = [];
elseif strcmp(mode, 'App_Jacobian') && strcmp(mode, 'Jacobian')
    [imDx, imDy] = gradient(im); %image gradient
else
    error('ml_cmpMpieAppNJacobian.m: Valid options for "mode" are App, Jacobian, App_Jacobian');
end;

[I, J] = ml_cmpMpieAppNJacobian_helper(im, imDx, imDy, shpParam, ptchXYIs, ShpBasis, mode);
    

