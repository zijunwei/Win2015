function energy = ml_cmpEnergy(label, unaryE, pairwiseE, edges)
% energy = ml_cmpEnergy(label, unaryE, pairwiseE, edges)
% Perform energy minimization using alpha-expansion algorithm. 
% Input:
%   label: a column vector of size nNodes indicate the labels of nodes. The range of 
%       legal labels is [1,..,nLables].
%   unaryE: a nNodes*nLabels matrix that defines the unary potential pairs of (node, label)
%   pairwiseE: nEdges*nLabels*nLabels matrix - potential for each pairwise labeling.
%   edges: nEdges*2 - node indexes of edges.
%
% Output:
%   energy: the energy corresponding to the labelling.
% Other notes: use others/m_testAlphaExpansion.m to test this function.
% By: Minh Hoai Nguyen
% Date: 1 August 07.

[nNodes, nLabels] = size(unaryE);
unaryCost = sum(unaryE(sub2ind([nNodes, nLabels], (1:nNodes)', label)));

nEdges = size(edges,1);
edgeCost = sum(pairwiseE(sub2ind(size(pairwiseE), (1:nEdges)', label(edges(:,1)), label(edges(:,2)))));
energy = unaryCost + edgeCost;
