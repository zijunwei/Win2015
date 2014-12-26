function [AlgnParams, AlgnLmPts] = ml_procrustes_helper(LmPts, stdShp, lmPtIdxs)
% function [AlgnParams, AlgnLmPts] = ml_procrustes_helper(LmPts, stdShp)
% Find the affine alignment parameters to align the landmark points to
% a standard shape.
% Inputs:
%   LmPts: 2k*n matrix for positions of k 2D-landmark points of n shapes.
%       For each column, the first k entries are X coordinates, 
%       and the last are Y coords.    
%   stdShp: 2k*1 vector for the standardized shape.
%       The first k entries are X coords, and the last are Y coords.
%   lmPtIdxs: indexes of landmark points used for alignment.
% Outputs:
%   AlgnParams: affine alignment parameters.
%   AlgnLmPts: warped shapes.
% By: Minh Hoai Nguyen
% Date: 28 Sep 2008

[d, n] = size(LmPts);
k = d/2;

if ~exist('lmPtIdxs', 'var') || isempty(lmPtIdxs)
    lmPtIdxs = 1:k;
end;
k2 = length(lmPtIdxs);

AlgnParams = zeros(6, n);
scl = max(abs(LmPts), [], 1);
LmPts = LmPts./repmat(scl, d, 1);
AlgnLmPts = zeros(d, n);
for i=1:n
    M = [LmPts(lmPtIdxs,i), LmPts(k+lmPtIdxs,i), ones(k2, 1)];
    A = M\[stdShp(lmPtIdxs), stdShp(k+lmPtIdxs)];
    AlgnParams(:,i) = A(:);
    N = [LmPts(1:k, i), LmPts(k+1:d,i), ones(k, 1)];
    AlgnLmPts(1:k,i) = N*A(:,1);
    AlgnLmPts(k+1:d,i) = N*A(:,2);
end;
AlgnParams([1 2 4 5],:) = AlgnParams([1 2 4 5],:)./repmat(scl, 4, 1);


