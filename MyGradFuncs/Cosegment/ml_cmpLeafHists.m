function histo = ml_cmpLeafHists(imAssign, nHistBin, rec, nBranch, nLevel, isKpAssign)
% histo = ml_cmpLeafHists(imAssign, nHistBin, rec, nBranch, nLevel, isKpAssign)
% compute histograms for subwindows at the depest levels.
% Inputs:
%   imAssign can be of two formats.
%       format 1: a 3D imH*imW array of positive integers, 
%       imAssigns(i,j) indicates which histogram bin in the histogram 
%       the pixel (i,j) is assigned to.
%       format 2: a n*3 matrix for keypoint assignment. 
%       imAssign(i,:) is [row#, col#, bin#] of i^th kp.
%       The input param isKpAssign indicates which format is used.
%   nHistBin: # bin
%   rec: [left, top, right, bottom] of the rectangular region.
%   nBranch: a squared integer, branch factor
%   nLevel: number of levels of the pyramid
%   isKpAssign: is imAssign is given in term of kepoint assignment
% Outputs:
%   histo: a nHistBin*(nBranch^(nLevel-1)) matrix.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 26 Dec 08
% Last modified: 31 Jan 09

if (nLevel == 1)
    if rec(1) ==0
        histo = zeros(nHistBin, 1);
    else
        if ~exist('isKpAssign', 'var') || ~isKpAssign  % format 1, 
            mask = zeros(size(imAssign));
            mask(rec(2):rec(4), rec(1):rec(3)) = 1;
            histo = ml_cmpRegHist_multi(imAssign, nHistBin, mask);
        else % format 2
            idxs1 = and(imAssign(:,1) >= rec(2), imAssign(:,1) <= rec(4));
            idxs2 = and(imAssign(:,2) >= rec(1), imAssign(:,2) <= rec(3));
            idxs = and(idxs1, idxs2);
            histo = hist(imAssign(idxs, 3), 1:nHistBin);
            histo = histo(:);
        end;
    end
else 
    histo = zeros(nHistBin, nBranch^(nLevel-1));
    sz = nBranch^(nLevel-2);
    sqrtBranch = sqrt(nBranch);
    xDev = sqrtBranch;
    yDev = sqrtBranch;
    for x=1:xDev
        for y=1:yDev
            subRec_i = cmpSubWindow(rec, x, y, xDev, yDev);
            histo_i = ml_cmpLeafHists(imAssign, nHistBin, subRec_i, ...
                nBranch, nLevel-1, isKpAssign);
            histo(:, (1+((y-1) + (x-1)*xDev)*sz):((y + (x-1)*xDev))*sz) = histo_i;
        end;
    end;
end;

function subRec = cmpSubWindow(rec, x, y, xDev, yDev)
    ul_x = rec(1);
    ul_y = rec(2);
    lr_x = rec(3);
    lr_y = rec(4);
    subRec(1) = ul_x + ceil((lr_x - ul_x + 1)*(x-1)/xDev);
    subRec(3) = ul_x + ceil((lr_x - ul_x + 1)*x/xDev)  - 1;
    subRec(2) = ul_y + ceil((lr_y - ul_y + 1)*(y-1)/yDev);
    subRec(4) = ul_y + ceil((lr_y - ul_y + 1)*y/yDev) - 1;
    
    if subRec(1) > subRec(3) || subRec(2) > subRec(4)
        subRec = [0 0 0 0];
    end;