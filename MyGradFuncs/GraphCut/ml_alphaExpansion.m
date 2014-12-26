function [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha)
% [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha)
% Performs a single alpha-expansion step for energy minimization problem using graph cut.
% Input:
%   curLabel: a column vector of size nNodes indicate the current labels of nodes. The range of 
%       legal labels is [1,..,nLables].
%   unaryE: a nNodes*nLabels matrix that defines the unary potential pairs of (node, label)
%   pairwiseE: nEdges*nLabels*nLabels matrix - potential for each pairwise labeling.
%   edges: nEdges*2 - node indexes of edges.
%   alpha - current label being expanded
%
% Output:
%   newLabel: nNodes*1 matrix - labels after alpha expansion.
%   energy: the energy corresponding to the new labelling.
% By: Minh Hoai Nguyen
% Date: 27 July 07.

VERY_BIG = 10^6; % should not use inf because this will be passed to C++ function.
nNodes = numel(curLabel);

% set capacity from nodes to the SOURCE (alpha) and SINK (not alpha)
ind1 = (1:nNodes)' + (alpha-1)*nNodes;
ind2 = (1:nNodes)' + (curLabel-1)*nNodes;
nodeCaps = [unaryE(ind1) unaryE(ind2)];
nodeCaps(curLabel==alpha, 2) = VERY_BIG;
nodeData = [(1:nNodes)', nodeCaps]; % cap to SOURCE and SINK respectively.


% new nodes are created, update the capacities to the SOURCE and SINK
if size(edges,1) == 1 % a special case.
    edgeLabels = curLabel(edges)';
else
    edgeLabels = curLabel(edges);
end;
diffIdxs = edgeLabels(:,1) ~= edgeLabels(:,2); %indexes of edges with different labels at two ends.
sameIdxs = edgeLabels(:,1) == edgeLabels(:,2); 
nExtraNodes = sum(diffIdxs);
if (nExtraNodes > 0)
    linIdxs = sub2ind(size(pairwiseE), find(diffIdxs), edgeLabels(diffIdxs, 1), edgeLabels(diffIdxs,2));
    nodeData(nNodes+1:nNodes+nExtraNodes,:) = [nNodes + find(diffIdxs), zeros(nExtraNodes,1), pairwiseE(linIdxs)];
end;
    

% create pairwise potentials for edges
if ~isempty(find(sameIdxs,1))
    linIdxs2 = sub2ind(size(pairwiseE), find(sameIdxs), edgeLabels(sameIdxs,1), alpha*ones(sum(sameIdxs),1));
    edgeData = [edges(sameIdxs,1), edges(sameIdxs,2), pairwiseE(linIdxs2), pairwiseE(linIdxs2)];
else
    edgeData = zeros(0,4);
end;


%create pairwise potentials for extra edges.
if (nExtraNodes > 0)
    linIdxs3a = sub2ind(size(pairwiseE), find(diffIdxs), edgeLabels(diffIdxs,1), alpha*ones(nExtraNodes,1));
    linIdxs3b = sub2ind(size(pairwiseE), find(diffIdxs), edgeLabels(diffIdxs,2), alpha*ones(nExtraNodes,1));
    extraEdges1 = [nNodes + find(diffIdxs), edges(diffIdxs,1), pairwiseE(linIdxs3a), pairwiseE(linIdxs3a)];
    extraEdges2 = [nNodes + find(diffIdxs), edges(diffIdxs,2), pairwiseE(linIdxs3b), pairwiseE(linIdxs3b)];
else
    extraEdges1 = zeros(0,4);
    extraEdges2 = zeros(0,4);
end;
edgeData = [edgeData; extraEdges1; extraEdges2];

[indicatorVec, energy] = ml_graphCut(nodeData, edgeData);
indicatorVec = indicatorVec(1:nNodes);
newLabel = curLabel;
newLabel(~indicatorVec) = alpha;




