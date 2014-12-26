function [ptchXYIs, ptchXYI0s] = ml_mpieFacePtchs(imSz, lmPts, hPtchSz)
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
%   
% By: Minh Hoai Nguyen
% Date: 23 May 07


% face mask
mask = ml_mpieFaceReg(imSz, lmPts, 'face');

[wXI, wYI] = meshgrid(-hPtchSz:hPtchSz, -hPtchSz:hPtchSz);
wXI = wXI(:); wYI = wYI(:);

nPix = length(wXI);
tmpX = repmat(lmPts(:,1),1,nPix)';
XI =  tmpX(:) + repmat(wXI, 68, 1);
tmpY = repmat(lmPts(:,2),1,nPix)';
YI =  tmpY(:) + repmat(wYI, 68, 1);

XGrid = [1 1 imSz(1)];
YGrid = [1 1 imSz(2)];
Z = qqinterp2(XGrid,YGrid, XI,YI, double(mask));

ptchXYIs = cell(68,1); ptchXYI0s = cell(68,1);
for i=1:68
    iZ = Z(1+nPix*(i-1):nPix*i);
    inMask = iZ > 0;
    ptchXYI0s{i} = [wXI(inMask), wYI(inMask)]; %offsets
    ptchXYIs{i} = ptchXYI0s{i} + repmat(lmPts(i,:), size(ptchXYI0s{i},1),1);
end;


