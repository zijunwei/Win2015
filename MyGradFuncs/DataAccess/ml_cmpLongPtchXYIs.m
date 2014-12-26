function [XI, YI, lShpBasisX, lShpBasisY] = ...
        ml_cmpLongPtchXYIs(ptchXYIs, shpBasis)
% [XI, YI, lShpBasisX, lShpBasisY] = ml_cmpLongPtchXYIs(ptchXYIs, shpBasis)    
% This function appends pixels in ptchXYIs into a long list format.
% Inputs:
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. ptchXYIs is computed
%       by function: ml_mpieFacePtchs. Look at that function for more
%       details.
%   shpBasis: the basis of shape variations. Each column is a basis vector.
%       Look at function ml_mpieShpPCA for more details.
% Outputs:
%   XI, YI: X and Y indexes of pixels in regions defined in ptchXYIs.
%   lShpBasisX, lShpBasisY: long shape and basis of shape variations for X
%       and Y components.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 26 May 07
    

shpBasisX = shpBasis(1:68,:);
shpBasisY = shpBasis(69:end, :);

counter = 0;
for i=1:68
    nPix = size(ptchXYIs{i},1);
    XYI(1+counter:counter+nPix,:) = ptchXYIs{i}; %concatenated XYI

    %concatenated shape basis vectors, X and Y components
    lShpBasisX(1+counter:counter+nPix,:) = repmat(shpBasisX(i,:),nPix,1);
    lShpBasisY(1+counter:counter+nPix,:) = repmat(shpBasisY(i,:),nPix,1);        
    counter = counter + nPix;
end;
XI = XYI(:,1); YI = XYI(:,2);