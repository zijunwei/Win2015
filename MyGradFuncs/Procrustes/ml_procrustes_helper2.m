function [AlgnParams, AlgnLmPts] = ml_procrustes_helper2(LmPts, stdShp, W)
% function [AlgnParams, AlgnLmPts] = ml_procrustes_helper(LmPts, stdShp)
% Find the affine alignment parameters to align the landmark points to
% a standard shape.
% Inputs:
%   LmPts: 2k*n matrix for positions of k 2D-landmark points of n shapes.
%       For each column, the first k entries are X coordinates, 
%       and the last are Y coords.    
%   stdShp: 2k*1 vector for the standardized shape.
%       The first k entries are X coords, and the last are Y coords.
%   W: k*1 vector for the weights of different landmarks.
% Outputs:
%   AlgnParams: affine alignment parameters.
%   AlgnLmPts: warped shapes.
% By: Minh Hoai Nguyen
% Date: 28 Sep 2008

[d, n] = size(LmPts);
k = d/2;

if ~exist('W', 'var') || isempty(W)
    W = ones(k,1);
end;

AlgnParams = zeros(6, n);
scl = max(abs(LmPts), [], 1);
LmPts = LmPts./repmat(scl, d, 1);
AlgnLmPts = zeros(d, n);
WstdShp = [W.*stdShp(1:k), W.*stdShp(1+k:d)];
for i=1:n
    M = [LmPts(1:k,i), LmPts(1+k:end,i), ones(k, 1)];
    M = repmat(W,1,3).*M;
    A = M\WstdShp;
    AlgnParams(:,i) = A(:);
    N = [LmPts(1:k, i), LmPts(k+1:d,i), ones(k, 1)];
    AlgnLmPts(1:k,i) = N*A(:,1);
    AlgnLmPts(k+1:d,i) = N*A(:,2);
end;
AlgnParams([1 2 4 5],:) = AlgnParams([1 2 4 5],:)./repmat(scl, 4, 1);


