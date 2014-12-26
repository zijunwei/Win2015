function [mShape, AlgnParams] = ml_mpieShpAffAlgn(lmFileList, scl, lmPtIdxs)
% function AlgnParams = ml_mpieShpAffAlgn(lmFileList)
% This function computes affine alignment parameters for shapes of MPie
% database. This function first computes the mean shape. For each of 
% particular shape this function computes the transformation parameters that
% will bring the mean shape to that shape as close as possible in least
% square error sense.
% Inputs:
%   lmFileList: the list of name and path to landmark files of face images.
%   scl: the scale factor
%   lmPtIdxs: images in MPIE database has 68 landmarks, however, if
%       lmPtIdxs is not empty, this function will align using only the
%       landmark points specified by indexes in lmPtIdxs.  
% Outputs:
%   mShape: the mean shape, this is 68*2 matrix.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
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

mShape_k = [mShape_k(1:k), mShape_k(1+k:end), ones(k,1)];
mShape = [mShape(1:68), mShape(69:end)];

A = inv(mShape_k'*mShape_k);
AlgnParams = zeros(6, size(lmFileList,1));
for i=1:size(lmFileList,1)
    % M is the 3*3 affine transformation matrix that transforms the
    % mean shape to the shape defined by landmark file i_th.
    M = ([LmPts_k(1:k,i)'; LmPts_k(1+k:end,i)'; ones(1,k)]*mShape_k)*A;
    AlgnParams(:,i) = [M(1,:)'; M(2,:)'];
end;

