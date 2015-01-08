function [mShape, AlgnParams, NRAlgnParams, AlgnShps, ShpBasis] = ...
    ml_mpieShpAffPCA(lmFileList, scl, k, pcaMode, lmPtIdxs)
% [mShape, AlgnParams, NRAlgnParams, AlgnShps, ShpBasis] = ...
%   ml_mpieShpPCA(lmFileList, scl, k, pcaMode)
% This function compute shape subspace for MPIE database. It first compute 
% the mean shape. For each of particular shape this function compute the 
% transformation parameters that will bring the mean shape to that shape 
% as close as possible in least square error sense.
% Inputs:
%   lmFileList: the list of name and path to landmark files of face images.
%   scl: the scale factor
%   k, pcaMode: if pcaMode is 1, k is a real number from 0 to 1 indicates
%       the desize energy. If pcaMode is not 1, k is the number of desire
%       principle components.
%   lmPtIdxs: images in MPIE database has 68 landmarks, however, if
%       lmPtIdxs is not empty, this function will align using only the
%       landmark points specified by indexes in lmPtIdxs.
% Outputs:
%   mShape: the mean shape, this is a 136*1 matrix.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
%       will bring the mean shape (after adding some shape variation) to 
%       the shape defined by landmark file i_th [x';y';1] = M*[x; y; 1];
%   NRAlgnParams: align params for non-rigid transformation. Each column 
%       u = NRAlgnParams(:,i) is a vector that defines nonrigid
%       transformation parameters. 
%   AlgnShps: each comlumn is a shape vector after warping a particular
%       shape to the mean shape using affine transformation.
%   ShpBasis: The basis of shape variation.
%
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 15 June 07


if ~exist('lmPtIdxs', 'var') || isempty(lmPtIdxs)
    lmPtIdxs = 1:68;
end;
[mShape, AlgnParams] = ml_mpieShpAffAlgn(lmFileList, scl, lmPtIdxs);

AlgnShps = zeros(136, size(lmFileList,1));
for i=1:size(lmFileList,1)
    load(lmFileList{i}, 'pts');
    pts = scl*pts;
    % M: 3*3 affine transformation matrix that transforms a particular
    % shape to the mean shape. 
    M = inv([AlgnParams(1:3,i)'; AlgnParams(4:6,i)'; 0 0 1]);
    aPts = M*[pts'; ones(1, size(pts,1))];
    AlgnShps(:,i) = [aPts(1,:)'; aPts(2,:)'];    
end;

mShape = mShape(:);
cenAlgnShps = AlgnShps - repmat(mShape, 1, size(AlgnShps,2));
[ShpBasis, sVals, NRAlgnParams] = ml_pca2(cenAlgnShps, k, pcaMode);
