function [mShape, AlgnParams] = ml_mpieShpEuclidAlgn(lmFileList, scl, lmPtIdxs)
% [mShape, AlgnParams] = ml_mpieShpEuclidAlgn(lmFileList, slc, lmPtIdxs)
% This function compute Euclidean alignment parameters (rotation, scale
% translation for shapes of MPIE database. This function first compute the 
% mean shape. For each of particular shape this function compute the 
% transformation parameters that will bring the mean shape to that shape 
% as close as possible in least square error sense.
% Inputs:
%   lmFileList: the list of name and path to landmark files of face images.
%   scl: the scale factor
%   lmPtIdxs: images in MPIE database has 68 landmarks, however, if
%       lmPtIdxs is not empty, this function will align using only the
%       landmark points specified by indexes in lmPtIdxs.
% Outputs:
%   mShape: the mean shape, this is 68*2 matrix.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 4-vector that defines 
%       4 Euclidean transformation parameters. The matrix
%       M = [v(1) -v(2) v(3); v(2) v(1) v(4); 0 0 1] is the matrix that
%       will bring the mean shape to the shape defined by landmark file i_th
%       [x';y';1] = M*[x; y; 1];
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 15 June 07

if ~exist('scl','var')
    scl = 1;
end;

if ~exist('lmPtIdxs', 'var') || isempty(lmPtIdxs)
    lmPtIdxs = 1:68;
end;

LmPts = zeros(136, size(lmFileList,1));
for i=1:size(lmFileList,1)
    load(lmFileList{i}, 'pts');

    LmPts(:,i) = scl*pts(:);
    pts = pts(lmPtIdxs,:);
    LmPts_k(:,i) = scl*pts(:);
end;

mShape = mean(LmPts, 2); % the mean shape of 68-landmark shapes.
mShape_k = mean(LmPts_k,2); % The mean shape of the landmarks used for alignment only.

k = length(lmPtIdxs); %number of landmark points used.

mShape_k = [mShape_k(1:k), mShape_k(1+k:end)];
mShape = [mShape(1:68), mShape(69:end)];

A = zeros(2*k, 4);
A(:,1) = [mShape_k(:,1); mShape_k(:,2)];
A(:,2) = [-mShape_k(:,2); mShape_k(:,1)];
A(1:k,3) = 1;
A(1+k:end, 4) = 1;
invAtA = inv(A'*A);

AlgnParams = zeros(4, size(lmFileList,1));
for i=1:size(lmFileList,1)
    AlgnParams(:,i) = invAtA*(A'*LmPts_k(:,i));
end;

