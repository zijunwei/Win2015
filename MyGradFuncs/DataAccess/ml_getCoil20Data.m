function D = ml_getCoil20Data(objectIDs, viewIDs, scl)
% D = ml_getCoil20Data(objectIDs, viewIDs)
% D = ml_getCoil20Data(objectIDs, viewIDs, scl)
% D = ml_getCoil20Data(objectIDs, viewIDs, scl, mode)
% Get the data from Coil-20 database. Coil-20 database consists of 20
% objects, each object has 72 views (images). The original size of images
% are 128*128.
% Inputs:
%   objectIDs: IDs of objects that we want to retrieve images. This should
%       be a list in which each entry is in [1,20].
%   viewIDs: IDs of views that we want to get. This should be a list in
%       which each entry is in [0,71]
%   scl: how much should we scale the image. This is a real number, the
%       default value is 1 (no-scale)
% Outputs:
%   D: Data in column format.
% By Minh Hoai Nguyen
% Date: 3 June 07.

if ~exist('scl','var')
    scl = 1;
end;

dataDIR = 'D:\Study\DataSets\coil-20-proc\';
imW = round(scl*128);
imH = imW;
count = 0;
for id=objectIDs
    for view=viewIDs
        fileName = sprintf('obj%d__%d.png',id, view);
        im = imread([dataDIR, fileName], 'png');
        im = imresize(im, [imH, imW]);
        count = count + 1;
        D(:,count) = im(:);            
    end;
end;
D = double(D);