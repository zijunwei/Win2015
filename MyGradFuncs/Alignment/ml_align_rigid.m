function [accM, winIm, XI, YI] = ml_align_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp)
% [accM, winIm, XI, YI] = m_align_rigid(D, im, kOpts, XI, YI, mode)
% [accM, winIm, XI, YI] = m_align_rigid(D, im, kOpts, XI, YI, mode, M0)
% [accM, winIm, XI, YI] = m_align_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp)
% This function does alignment for rigid transformation. There are
% two type of transformation supported: affine and translation. This
% function calls the appropriate function for kernel alignment or linear
% alignment.
% Inputs:
%   D: The data given in column format.
%   im: the test image, that we need to to find alignment parameters.
%   kOpts: the structure that define kernel options.
%       kOpts.kernelType: type of kernel, either 'exp', 'poly', or 'linear'
%       kOpts.deg: if the kernel type is 'poly', what degree.
%       kOpts.gamma: if kernel is 'exp': k(x,y) = exp(-gamma*||x-y||^2)
%           if kernel is 'poly', k(x,y) = (<x,y> + gamma)^deg
%       kOpts.energy: the energy level that we want to preserve.
%   XI, YI: The X and Y indexes of pixels that we need to align (initial
%       positions). XI, YI are two column vectors.
%   mode: type of transformation used, two possible values: 'affine' or
%       'translation'. mode is a string.
%   M0: the initial estimate of transformation parameters. See output accM 
%       for more details about format. If no intial estimate, M0 should be
%       set of [].
%   shldDisp: should display details of each iteration or not. The default
%       value is false.
% Outputs:
%   accM: accumuated transformation. accM is  the transformation params
%       that bring the XI, YI to correct positions. If mode is 'affine',
%       accM and M0 are 3*3 matrix. If mode is 'translation', accM and M0
%       are 2*1 translation vectors.
%   winIm: the value of pixels at the aligned position (final iteration).
%   XI, YI: final positions of initial XI, YI after transformation.
% By Minh Hoai Nguyen
% Date: 12 June 07

if ~exist('M0', 'var')
    M0 = [];
end;
if ~exist('shldDisp', 'var')
    shldDisp = 0;
end;

kernelType = kOpts.kernelType;

if strcmp(kernelType, 'linear')
    [accM, winIm, XI, YI] = m_linearAlign_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp);
else
    [accM, winIm, XI, YI] = m_kAlign_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp);
end;

