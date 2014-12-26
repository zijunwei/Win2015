function [descriptors, CharScl] = ...
    ml_cmpDenseSIFT(imFile, imScl, minSiftScl, maxSiftScl, noOrient)
% function [descriptors, CharScl] = ...
%    ml_cmpDenseSIFT(imFile, imScl, minSiftScl, maxSiftScl)
% Compute the dense SIFT features.
% Inputs:
%   imFile: name of the image file
%   imScl: scale factor for image. e.g. 0.25 -> scale size image down by a
%       factor of 4.
%   minSiftScl, maxSiftScl: min and max SIFT scales. 
%       This function first finds a characteristic scales using
%       extremum of Laplician in scale space. It then copute descriptor at
%       that scale. 
%       If minSiftScl = maxSiftScl, the scale is fixed.
% Outputs:
%   descriptors: dense feature vector. This is a imH*imW*128 matrix.
%   CharScl: imH*imW for the characteristic scales.
% By: Minh Hoai Nguyen (t-minguy@microsoft.com)
% Date: 20 June 2008.
% Last modified: 7 Nov 2008



%SIFTPP= 'D:\Study\Projects\Minh_siftpp\Release\siftpp';
SIFTPP= '/Users/hoai/Study/Projects/Minh_siftpp/sift';

SHLD_DEL_TMP_FILE = 1; % should we delete temporary files?

if ~exist('imScl', 'var') || isempty(imScl)
    imScl = 1;
end;

if ~exist('minSiftScl', 'var') || isempty(minSiftScl)
    minSiftScl = 3;
end;
if ~exist('maxSiftScl', 'var') || isempty(maxSiftScl)
    maxSiftScl = 3;
end;

if ~exist('noOrient', 'var') || isempty(noOrient)
    noOrient = 0;
end;

im = imread(imFile);
if size(im,3) > 1
    im = rgb2gray(im);
end;
im = imresize(double(im), imScl);

[pathstr, name] = fileparts(imFile);

tmpDir = pwd; %can be replaced by pathstr.
% tmpDir = 'D:\Study\Binaries\tmp\SIFT\';


pgmFile = [tmpDir, '/', name, '.pgm'];
warning off;
imwrite(uint8(round(im)), pgmFile, 'pgm');
warning on;


[imH, imW, imDim] = size(im);
[IX, IY]= meshgrid(1:imW, 1:imH);
keypoints = zeros(numel(IX), 3);
keypoints(:,1:2) = [IX(:), IY(:)];

if minSiftScl < maxSiftScl
    CharScl = ml_cmpCharScl(im, minSiftScl, maxSiftScl);
else
    CharScl = repmat(minSiftScl, imH, imW);
end;

keypoints(:, 3) = CharScl(:);

%sort keypoints based on scale for faster computation.
%this is possible becasue sifpp cache things.
%if you move to different scale, the cache is cleared.
[dc, idxs] = sort(keypoints(:,3));
keypoints = keypoints(idxs,:);


keypointFile = [tmpDir, '/', name, '_keypnts.txt'];
save(keypointFile, 'keypoints', '-ASCII');      
warning off;
if ~noOrient
    system(sprintf('%s --stable-order --keypoints=%s %s', SIFTPP, keypointFile, pgmFile)); 
else
    system(sprintf('%s --stable-order --no-orientations --keypoints=%s %s', SIFTPP, keypointFile, pgmFile)); 
end;
warning on;
descriptorFile = [tmpDir, '/', name, '.key'];

descriptors = load(descriptorFile);

% undo the idxs
[dc, idxs2] = sort(idxs);
descriptors = descriptors(idxs2, 5:end);

% Normalize the descriptors, as described in Lowe's IJCV paper.
descriptors = descriptors./repmat(sqrt(sum(descriptors.^2, 2)) + eps, ...
    1, size(descriptors,2));
descriptors(descriptors > 0.2) = 0.2;
descriptors = descriptors./repmat(sqrt(sum(descriptors.^2, 2)) + eps, ...
    1, size(descriptors,2));
descriptors = reshape(descriptors, imH, imW, 128);

if SHLD_DEL_TMP_FILE
    delete(pgmFile);
    delete(keypointFile);
    delete(descriptorFile);
end;

