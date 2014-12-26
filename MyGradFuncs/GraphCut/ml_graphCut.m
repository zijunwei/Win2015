function [indicatorVec, flow] = ml_graphCut(nodeData, edgeData)
% [indicatorVec, flow] = ml_graphCut(nodeData, edgeData)
% Perform min-cut/max-flow algorithm for graph. This function calls the function implemented
% in C++ by Yuri Boykov and Vladimir Kolmogorov version 3.0.
% http://www.adastral.ucl.ac.uk/~vladkolm/software/maxflow-v3.0.src.tar.gz
% Inputs:
%   nodeData: a n*3 matrix, n: number of nodes (apart from the SOURCE and the SINK). 
%       Each row i^th contains info for a node. nodeData(i, 1) is the ID of node i^th. 
%       nodeData(i,2) and nodeData(i,3) are the capacities from the SOURCE to node i^th 
%       and from node i^th to the SINK respectively. 
%   edgeData: a m*4 matrix where m is number of edges. Each row contains info for an edge.
%       edgeData(i,1) and edgeData(i,2) are the node IDs for an edge.
%       edgeData(i,3): capacity from edgeData(i,1) to edgeData(i,2)
%       edgeData(i,4): capacity from edgeData(i,2) to edgeData(i,1)
% Outputs:
%   indicatorVec: the indicator vector produced by min-cut/max-flow algorithm. indicatorVec(i)
%       is 1 or 0 depending on whether nodeData(i,1) is in the SOURCE or the SINK set. 
%   flow: the maximum flow = the minimum cut = the sum of capacities of cut edges. 
% By: Minh Hoai Nguyen
% Date: 27 July 07

[indicatorVec, flow] = m_mexGC(nodeData, edgeData);
indicatorVec = logical(indicatorVec);