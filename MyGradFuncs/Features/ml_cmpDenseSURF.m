function [descriptors, CharScl] = ml_cmpDenseSURF(imFile, imScl, ...
    minSurfScl, maxSurfScl, upSurf)
% function descriptors = ml_cmpDenseSURF(imFile)    
% descriptors = ml_cmpDenseSURF(imFile, imScl, minSurfScl, maxSurfScl, upSurf)
% Compute the dense SURF features.
% Inputs:
%   imFile: name of the image file
%   imScl: scale factor for image. e.g. 0.25 -> scale size image down by a
%       factor of 4.
%   minSurfScl, maxSurfScl: min and max surf scales. 
%       This function first finds a characteristic scales using
%       extremum of Laplician in scale space. It then copute descriptor at
%       that scale. 
%       If minSurfScl = maxSurfScl, the scale is fixed.
%   upSurf: if uSurf is 1, the descriptor is not rotation
%       invariant. The default value is 0.
% Outputs:
%   descriptors: dense feature vector. This is a imH*imW*64 matrix.
%   CharScl: imH*imW for the characteristic scales.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 5 Nov 08

SURFEXE= 'D:\Study\Binaries\SURF\surfWINDLLDemo.exe';
SHLD_DEL_TMP_FILE = 1; % should we delete temporary files?

if ~exist('minSurfScl', 'var') || isempty(minSurfScl)
    minSurfScl = 3;
end;

if ~exist('maxSurfScl', 'var') || isempty(maxSurfScl)
    maxSurfScl = 3;
end;

if ~exist('imScl', 'var') || isempty(imScl)
    imScl = 1;
end;

if ~exist('upSurf', 'var') || isempty(upSurf)
    upSurf = 0;
end;

im = imread(imFile);
im = rgb2gray(im);
im = imresize(double(im), imScl);

[pathstr, name] = fileparts(imFile);

tmpDir = 'D:\Study\Binaries\tmp\SURF\'; %can be replaced by pathstr.

pgmFile = [tmpDir, '/', name, '.pgm'];
warning off;
imwrite(uint8(round(im)), pgmFile, 'pgm');
warning on;
[imH, imW, imDim] = size(im);
[IX, IY]= meshgrid(1:imW, 1:imH);

if minSurfScl < maxSurfScl
    CharScl = ml_cmpCharScl(im, minSurfScl, maxSurfScl);
else
    CharScl = repmat(minSurfScl, imH, imW);
end;

keypoints = zeros(numel(IX), 5);
keypoints(:,1:2) = [IX(:), IY(:)];
keypoints(:, 3) = 1./CharScl(:).^2;
keypoints(:, 5) = keypoints(:, 3);

keypointFile = [tmpDir, '/', name, '_keypnts.txt'];
surfFile = [tmpDir, '/', name, '.surf'];
surfFile2 = [tmpDir, '/', name, '2.surf'];

fid = fopen(keypointFile, 'w');
fprintf(fid, '0\n%d\n', size(keypoints,1));
fclose(fid);


save(keypointFile, 'keypoints', '-ASCII', '-append');      
warning off;
if ~upSurf
    system(sprintf('%s -i %s -o %s -v -p1 %s ', ...
        SURFEXE, pgmFile, surfFile, keypointFile)); 
else
    system(sprintf('%s -i %s -o %s -v -p1 %s -u', ...
        SURFEXE, pgmFile, surfFile, keypointFile)); 
end;
warning on;

% strim the first two lines.
fid = fopen(surfFile, 'r');
fid2 = fopen(surfFile2, 'w');
fgetl(fid);
fgetl(fid);
for i=1:size(keypoints,1)
    str = fgetl(fid);
    fprintf(fid2, '%s\n', str);
end;
fclose(fid2);
fclose(fid);

descriptors = load(surfFile2);

% Normalize the descriptors, as described in Lowe's IJCV paper.
descriptors = descriptors(:, 7:end);
% lapSigns = descriptors(:, 6);

descriptors = reshape(descriptors, imH, imW, 64);

if SHLD_DEL_TMP_FILE
    delete(pgmFile);
    delete(keypointFile);
    delete(surfFile);
    delete(surfFile2);
end;

