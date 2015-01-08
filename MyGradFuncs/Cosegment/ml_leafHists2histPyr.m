function histPyr = ml_leafHists2histPyr(leafHists, nBranch, nLevel)
% Turning the histograms at leaf level to the pyramid of histograms.
% Turning a pyramid of histograms to a tree of histograms.
% Inputs:
%   leafHists: a nHistBin*(nBranch^(nLevel-1)) matrix for the histograms at the
%       leaves.
%   nBranch: a squared integer.
%   nLevel: number of level of the pyramid.
% Outputs:
%   histPyr: pyramid of histogram, this is also a 2D matrix. 
%       histPyr is similar to leafHists which contain a number of
%       histograms. However, the difference is that histPyr contains
%       histograms at each tree (pyramid) node (not only at the leaves).
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 12 Jan 2009


if size(leafHists, 2) ~= nBranch^(nLevel -1)
    error('ml_leafHists2histPyr.m: mismatch between # of histograms and nBranch, nLevel');
end;

if (nLevel < 1)
    error('ml_leafHists2histPyr: nLevel must be a positive integer');
elseif nLevel == 1
    histPyr = leafHists;    
elseif nLevel == 2
    histPyr = [sum(leafHists, 2), leafHists];
else
    m = nBranch^(nLevel - 2);
    k = (nBranch^(nLevel - 1) - 1)/(nBranch - 1);
    histPyr = zeros(size(leafHists,1), (nBranch^nLevel- 1)/(nBranch - 1));
    histPyr(:,1) = sum(leafHists,2);
    for i=1:nBranch
        leafHists_i = leafHists(:, 1+(i-1)*m:i*m);
        histPyr_i = ml_leafHists2histPyr(leafHists_i, nBranch, nLevel - 1);
        histPyr(:, (2+(i-1)*k):(1+i*k)) = histPyr_i;
    end;
end;

