function D = ml_getALOIData(objIDs, lghtIDs, camIDs, scl)
% D = ml_getALOIData(objIDs, lghtIDs, camIDs)
% D = ml_getALOIData(objIDs, lghtIDs, camIDs, scl)
% Get data from the Amsterdam Library of Object Images
% Inputs:
%   objIDs: IDs of objects that we want. objIDs should be a vector in which
%       each entry is from 1 to 1000.
%   lghtIDs: IDs of lights that we want. lghtIDs should be a vector in which
%       each entry is from 1 to 8.
%   camIDs: IDs of cameras that we want. camIDs sould be vector in which
%       each entry is from 1 to 3.
%   scl: How much to scale down the images. Default value is 1.
% Outputs:
%   D: Data in column format.
% By: Minh Hoai Nguyen
% Date: 4 June 07

if ~exist('scl','var')
    scl = 1;
end;

dataDIR = 'D:\Study\DataSets\aloi_grey_red4_ill\grey4\';
imW = round(scl*192);
imH = round(scl*144);

count = 0;
for id=objIDs
    for lght=lghtIDs
        for cam=camIDs
            fileName = sprintf('%d\\%d_l%dc%d.png',id, id, lght, cam);
            im = imread([dataDIR, fileName], 'png');
            im = imresize(im, [imH, imW]);
            count = count + 1;
            D(:,count) = im(:); 
        end;
    end;
end;
D = double(D);