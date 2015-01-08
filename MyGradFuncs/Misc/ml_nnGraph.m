function [nnGraph, nnDist] = ml_nnGraph(Dist, k)
% function nnGraph = ml_nnGraph(Dist, k)
% Construct a sparse nearest neighbor graph.
% Inputs:
%   Dist: a n*n matrix for pairwise distances between data points. 
%   k: number of nearest neighbor considered.
% Outputs:
%   nnGraph: a sparse matrix, each non-zero entry is the distance between corresponding data points.
%   nnDist: distance between nearest neighbors. This is 3*m matrix where
%       m is the number of nearest neighbor pairs. For each column, the first 2 entries
%       are indexes of nearest neighbors and the 3rd entry is the distance.
%       The difference between nnGraph and nnDist are:
%           + nnGraph is a sparse matrix.
%           + nnDist is 3*m matrix.
%           + In nnDist, each edge is listed only once, no repetition, no duplicate.
%             In nnDist, if there is an edge b/t i and j and i<j then there is a triple
%             in which the first 2 entries are i and j (but NOT j and i).
%             In nnGraph, if there is edge b/t i and j, then there is an non-zero entries
%             for nnGraph(i,j) and nnGraph(j,i);
% Note: if you make any change, remember to update the pcode file.
% By: Minh Hoai Nguyen
% Date: 18 May 2008

n = size(Dist, 2);

[SortDist, IX] = sort(Dist, 2);   

IX = IX(:, 2:k+1);
nnPairs = [repmat((1:n)', k, 1), IX(:)];
nnPairs = sort(nnPairs, 2);

% remove duplicate entries.
IndMatrix = sparse(n, n);
linIdxs = sub2ind([n,n], nnPairs(:,1), nnPairs(:,2));
IndMatrix(linIdxs) = 1;
linIdxs = find(IndMatrix);
[I,J] = ind2sub([n,n], linIdxs);

nnDist =  [I'; J'; Dist(linIdxs)'];

% repeat edges for nearest neighbor graph
linIdxs2 = sub2ind([n, n], J', I');
nnGraph = sparse(n, n);
nnGraph(linIdxs) = Dist(linIdxs);
nnGraph(linIdxs2) = Dist(linIdxs2);



