function AlgnApps = ml_mpieAppAffAlgn(imFileList, AlgnParams, XI, YI, mode, scl)
% AlgnApps = ml_mpieAppAffAlgn(imFileList, AlgnParams, XI, YI, mode, scl)
% This function align images and extract pixel values for the region of
%   interest.
% Inputs:
%   imFileList: a list of names of image files.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
%       will align the mean shape to the shape of the i_th image.
%       [x';y';1] = M*[x; y; 1];
%   XI, YI: X and Y indexes of region of interest (e.g face) 
%       of the mean image, XI, YI should be two column vectors.
%   mode: either 'color' or 'gray', default: 'color'
%   scl: the scale of images that we should operate on, default: 1
% Outputs:
%   AlgnApps: column i_th is a vector containing pixel values of the
%       aligned region of interest in image i_th.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 11 May 07

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
    v = AlgnParams(:,i);
    M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1];
    warpXYI = [XI, YI, ones(length(XI),1)]*M';
    im = imread(imFileList{i});
    im = imresize(im, scl);
    if strcmp(mode, 'color')        
        im = double(im);
        [winImR, winImG, winImB] = qqinterp2(XGrid,YGrid, ...
            warpXYI(:,1), warpXYI(:,2), im(:,:,1), im(:,:,2), im(:,:,3));    
        AlgnApps(:,i) = [winImR; winImG; winImB];
    elseif strcmp(mode, 'gray')
        im = rgb2gray(im);
        winIm = qqinterp2(XGrid,YGrid, warpXYI(:,1), warpXYI(:,2), double(im));
        AlgnApps(:,i) = winIm;
    end;
end;
fprintf('\n');