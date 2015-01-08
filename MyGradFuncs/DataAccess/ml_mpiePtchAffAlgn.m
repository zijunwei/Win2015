function AlgnPtchApps = ml_mpiePtchAffAlgn(imFileList, AlgnParams, ...
    AlgnShps, ptchXYI0s, mode, scl)
% function AlgnPtchApps = ml_mpiePtchAffAlgn(imFileList, AlgnParams, ...
%       AlgnShps, ptchXYI0s, mode, scl)
%   Compute the patch appearance after align using non-rigid and affine transformation.
%   Although this function does not take in non-rigid alignment param NRAlgnParams, the 
%   reult are a patches aligned using both rigid and non-rigid parameters. The reason is
%   because AlgnShps are shapes before removing the non-rigid parameters.
%
% Inputs:
%   imFileList: a list of names of image files.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
%       will align the mean shape to the shape of the i_th image.
%       [x';y';1] = M*[x; y; 1];
%   AlgnShps: each comlumn is a shape vector after warping a particular
%       shape to the mean shape using affine transformation.
%   ptchXYI0s: This is a cell of 68 elements. ptchXYI0{i} is a n(i)*2
%       matrix which is the XI, YI offsets of pixels inside square patch
%       around the landmark i_th and inside the face with respect to the
%       landmark i_th.
%   mode: either 'color' or 'gray', default: 'color'
%   scl: the scale of images that we should operate on, default: 1
% Outputs:
%   AlgnPtchApps: rigid + non-rigid aligned patch appearance.
% See also: ml_mpiePtchNRAlgn.m. That function produces similar results to this function. The differences are:
%   + This function uses AlgnShps to determine the warped landmark points.
%   + The landmark points used by the other function are obtained by: (i) project AlgnShps to non-rigid 
%       shape basis, (ii) reconstruct the AlgnShps by the shape basis. There is something lost by during
%       projection and reconstruction.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 9 Oct 07

if ~exist('mode', 'var')
    mode = 'color';
end;
if ~exist('scl','var')
    scl = 1;
end;

im0 = imread(imFileList{1});
imH = round(size(im0,1)*scl);
imW = round(size(im0,2)*scl);

clear im0;
XGrid = [1 1 imH];
YGrid = [1 1 imW];

fprintf('Process image 0000');

for i=1:size(imFileList,1)
    fprintf('\b\b\b\b%4d', i);

    algnPts = [AlgnShps(1:68,i), AlgnShps(69:end,i)];
    counter = 0;
    for j=1:68
        nPix = size(ptchXYI0s{j},1);
        XYI(1+counter:counter+nPix,:) = ... 
            repmat(algnPts(j,:), nPix,1) + ptchXYI0s{j};
        counter = counter + nPix;
    end;
    
    % M: 3*3 affine transformation matrix that transforms the mean shape to 
    % a particular shape
    M = [AlgnParams(1:3,i)'; AlgnParams(4:6,i)'; 0 0 1];    
    warpXYI = [XYI, ones(size(XYI,1),1)]*M';
    
    im = imread(imFileList{i});
    im = imresize(im, scl);
    if strcmp(mode, 'color')        
        im = double(im);
        [winImR, winImG, winImB] = qqinterp2(XGrid,YGrid, ...
            warpXYI(:,1), warpXYI(:,2), im(:,:,1), im(:,:,2), im(:,:,3));    
        AlgnPtchApps(:,i) = [winImR; winImG; winImB];
    elseif strcmp(mode, 'gray')
        im = rgb2gray(im);
        winIm = qqinterp2(XGrid,YGrid, warpXYI(:,1), warpXYI(:,2), double(im));
        AlgnPtchApps(:,i) = winIm;
    end;
end;
fprintf('\n');
