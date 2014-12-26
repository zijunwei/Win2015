function A = ml_align_nonrigid(D, im, kOpts, ...
        ptchXYIs, mShp, shpBasis, A0, shldDisp)
% A = m_align_nonrigid(D, im, kOpts, ptchXYIs, mShp, shpBasis)    
% A = m_align_nonrigid(D, im, kOpts, ptchXYIs, mShp, shpBasis, A0)    
% A = m_align_nonrigid(D, im, kOpts, ptchXYIs, mShp, shpBasis, A0,shldDisp)
% This function computes the non-rigid transformation parameters for
% alignment system. This function calls either kernel or linear alignment
% system depending the setting of kOpts.kernelType.
% Inputs:
%   D: The data given in column format.
%   im: the test image, that we need to to find alignment parameters.
%   kOpts: the structure that define kernel options.
%       kOpts.kernelType: type of kernel, either 'exp', 'poly',or 'linear'
%       kOpts.deg: if the kernel type is 'poly', what degree.
%       kOpts.gamma: if kernel is 'exp': k(x,y) = exp(-gamma*||x-y||^2)
%           if kernel is 'poly', k(x,y) = (<x,y> + gamma)^deg
%       kOpts.energy: energy level that KPCA should preserve.
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. ptchXYIs is computed
%       by function: ml_mpieFacePtchs. Look at that function for more
%       details.
%   mShp: mean shape of landmark points. This is a column vector.
%   shpBasis: the basis of shape variations. Each column is a basis vector.
%       Look at function ml_mpieShpPCA for more details.
%   A0: intial estimate of transformation params. This could be se to [].
%   shldDisp: should display details of each iteration. If this is set to
%       be 1. The function will compute kernel PCA reconstruction error at
%       each iteration and display it. It also display the aligned shape
%       using transformation params computed at each iteration. The default
%       value is 0 (false)
% Output:
%   A: Transformation parameters necessary for alignment. The first 6 
%       entries of A are for affine transformation. A(7:end) are for 
%       non-rigid transformation.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 12 June 07

    
if ~exist('A0', 'var')
    A0 = [];
end;
if ~exist('shldDisp', 'var')
    shldDisp = 0;
end;   
    
kernelType = kOpts.kernelType;

if strcmp(kernelType, 'linear')
    A =  m_linearAlign_nonrigid(D, im, kOpts, ...
        ptchXYIs, mShp, shpBasis, A0, shldDisp);
else
    A =  m_kAlign_nonrigid(D, im, kOpts, ...
        ptchXYIs, mShp, shpBasis, A0, shldDisp);
end;

