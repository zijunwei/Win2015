function [ptchXYIs, ptchXYI0s] = ml_mpieFacePtchs2(imSz, lmPts, scl)
% ptchXYIs = ml_mpieFacePtchs(imSz, lmPts, hPtchSz)
% We have 68 landmark points, we want the pixels that lie inside the 
% squares around the landmarks and also inside the face region. This 
% function find the X and Y indexes of those pixels.
% Inputs:
%   imSz: size of image.
%   lmPts: the 68*2 matrix that tell location of 68 landmarks.
%   hPtchSz: We use square axis aligned patches around landmarks. The size
%       of the patches are: 2*hPtchSz + 1.
% Outputs:
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. Note the number of 
%       pixels are different for different landmarks.
%   ptchXYI0s: This is a cell of 68 elements. ptchXYI0{i} is a n(i)*2
%       matrix which is the XI, YI offsets of pixels inside square patch
%       around the landmark i_th and inside the face with respect to the
%       landmark i_th.
% Other notes: See also: ./others/m_testMpieFacePtchs.m for usage example.  
% By: Minh Hoai Nguyen
% Date: 23 May 07


% face mask
mask = ml_mpieFaceReg(imSz, lmPts, 'face');

hPtchSzs = zeros(68,2);
%outer boundary of face
hPtchSzs([1:6, 12:17],:) = repmat([32,8], 12,1);
hPtchSzs([7,11],:) = repmat([8,4],2,1);
hPtchSzs([8,9,10],:) = repmat([8,20],3,1);


%eyebrows
hPtchSzs([18:27],:) = repmat([4,12],10,1);

%eyes
hPtchSzs([37:48],:) = repmat([4,8],12,1);
% 
%nose
hPtchSzs([28:31],:) = repmat([12,4],4,1);
hPtchSzs([32:36],:) = repmat([4,4], 5,1);
% 
% % %mouth
% hPtchSzs([49,55],:) = repmat([4,20],2,1);
% hPtchSzs([50,54, 56, 60],:) = repmat([8,8],4,1);
% hPtchSzs([51:53, 57:59],:) = repmat([8,8],6,1);
% % 
% % %inner mouth
% hPtchSzs(61:68, :) = repmat([6,20], 8, 1);
% 

%%%%%FOR display purpose ONLY
% % %mouth
hPtchSzs([49,55],:) = repmat([4,4],2,1);
hPtchSzs([50,54, 56, 60],:) = repmat([4,4],4,1);
hPtchSzs([51:53, 57:59],:) = repmat([4,4],6,1);
% 
% %inner mouth
hPtchSzs(61:68, :) = repmat([4,4], 8, 1);


hPtchSzs = round(hPtchSzs*scl);


endIdxs = zeros(69,1);
for i=1:68
    [wXI, wYI] = meshgrid(-hPtchSzs(i,1):hPtchSzs(i,1), ...
        -hPtchSzs(i,2):hPtchSzs(i,2));
    endIdxs(i+1) = endIdxs(i) + numel(wXI);
    XI(1+endIdxs(i):endIdxs(i+1)) = lmPts(i,1) + wXI(:); 
    YI(1+endIdxs(i):endIdxs(i+1)) = lmPts(i,2) + wYI(:);
end;

XGrid = [1 1 imSz(1)];
YGrid = [1 1 imSz(2)];
Z = qqinterp2(XGrid,YGrid, XI,YI, double(mask));

ptchXYIs = cell(68,1); ptchXYI0s = cell(68,1);
for i=1:68
    iZ = Z(1+endIdxs(i):endIdxs(i+1));
    inMask = iZ > 0;
    [wXI, wYI] = meshgrid(-hPtchSzs(i,1):hPtchSzs(i,1), ...
        -hPtchSzs(i,2):hPtchSzs(i,2));
    wXI = wXI(:); wYI = wYI(:);

    ptchXYI0s{i} = [wXI(inMask), wYI(inMask)]; %offsets
    ptchXYIs{i} = ptchXYI0s{i} + repmat(lmPts(i,:), size(ptchXYI0s{i},1),1);
end;


