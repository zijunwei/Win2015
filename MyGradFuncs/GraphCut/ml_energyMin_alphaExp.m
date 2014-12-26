function [label, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges, isVerbose)
% [label, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges)
% Perform energy minimization using alpha-expansion algorithm. 
% Input:
%   initLabel: a column vector of size nNodes indicate the initial labels of nodes. The range of 
%       legal labels is [1,..,nLables].
%   unaryE: a nNodes*nLabels matrix that defines the unary potential pairs of (node, label)
%   pairwiseE: nEdges*nLabels*nLabels matrix - potential for each pairwise labeling.
%   edges: nEdges*2 - node indexes of edges.
%   isVerbose: 0 or 1, depending on whether you want this function to printout debuging/info messages.
%       The default value is 0.
%
% Output:
%   label: nNodes*1 matrix - results of the algorithm, labels of nodes that minimize (hopefully) minimize the
%       energy function.
%   energy: the energy corresponding to the final labelling.
% By: Minh Hoai Nguyen
% Date: 1 August 07.

if ~exist('isVerbose', 'var')
    isVerbose = 0;
end;

nLabels = size(unaryE,2);
curLabel = initLabel;
curEnergy = ml_cmpEnergy(curLabel, unaryE, pairwiseE, edges);
nUpdates = 0;
nIters = 0;
while 1
    isSuccess = 0;
    nIters = nIters + 1;
    for alpha = 1:nLabels
        [newLabel, newEnergy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
        if newEnergy < curEnergy
            curLabel = newLabel;
            curEnergy = newEnergy;
            isSuccess = 1;
            nUpdates = nUpdates + 1;
            if isVerbose
                fprintf('label:'); fprintf(' %g', curLabel); fprintf('; energy: %g\n', curEnergy);
            end;
        end;
    end;
    if ~isSuccess
        break;
    end;   
end;

label = curLabel;
energy = curEnergy;

if isVerbose
    fprintf('ml_energyMin_alphaExp, # iters: %d, # updates: %d\n', nIters, nUpdates);
end;