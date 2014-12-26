function IDX = ml_spectralClustering(AffM, k, kMeanMaxIters)
% IDX = ml_spectralClustering(AffM, k, kMeanMaxIters)
% Spectral Clustering, implementation of:
% Ng, A. Y.; Jordan, M. I. & Weiss, Y. On Spectral Clustering: Analysis and an Algorithm 
% Advances in Neural Information Processing Systems 14, MIT Press, 2002
% Inputs:
%   AffM: a square n*n affinity matrix.
%   k: the number of clusters.
%   kMeanMaxIters: maximum number of iterations for kmeans.
% Outputs:
%   IDX: n*1 cluster assignment for the data. The entries of IDX are from 1 to k.
% By: Minh Hoai Nguyen
% Date: 24 Aug 07

[U,S,V] = svd(AffM);
U = U(:,1:k);

rowSS = sum(U.*U,2);

U = U./repmat(sqrt(rowSS), 1, k);

if ~exist('kMeanMaxIters', 'var') || isempty(kMeanMaxIters)
    IDX = kmeans(U, k);
else
    IDX = kmeans(U, k, 'maxiter', kMeanMaxIters);
end;
    