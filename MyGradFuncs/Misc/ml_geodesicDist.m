function [GeoDist, nnGraph, nnDist] = ml_geodesicDist(Dist, k)
% function GeoDist = ml_geodesicDist(D, k)
% Compute Geodesic distance between any two data points
% Inputs:
%   Dist: n*n matrix for pairwise distances between data points.
%   k: number of nearest neighbors used to construct nearest neighbor graph.
% Ouputs:
%   GeoDist: a n*n matrix for geodesic distance between data points in D.
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
% By: Minh Hoai Nguyen
% Date: 18 May 2008

n = size(Dist, 2);
[nnGraph, nnDist] = ml_nnGraph(Dist, k);
GeoDist = dijkstra(nnGraph, 1:n);
