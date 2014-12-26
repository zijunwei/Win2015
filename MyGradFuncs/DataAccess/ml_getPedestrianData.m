function D = ml_getPedestrianData(dataSet, dataType, mode, kk, shldDisp)
% D = ml_getPedestrianData(dataSet, dataType, mode, kk, shldDisp)
% Get pedestrian data from PGM images. This method is slower than ml_getPedestrianData_fast()
% Inputs:
%   dataSet: takes one of the following: '1', '2', '3', 'T1', or 'T2' which are 5 different parts
%       of the database. Data from different parts are mutually exclusive.
%   dataType: either 'positive' or 'negative', set to 'positive' for positive examples.
%   mode: either 'all', 'random', or 'indexes'. If mode is 'all', all positive or negative of the 
%       the specified data part are retrived. If mode is 'indexes', retrieve examples with indexes
%       specified in kk. If mode is 'random', retrieve kk random examples.
%   kk: See explanation for mode.
%   shldDisp: should we display the progress? default is no.
% Outputs:
%   D: data in column format.
% Other Notes: see also ml_getPedestrianData_fast.m
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 13 August 2007

DIR = 'D:\Study\DataSets\Pedestrian\DC-ped-dataset_base';

if ~exist('shldDisp', 'var')
    shldDisp = 0;
end;

if ~strcmp(dataSet, '1') && ~strcmp(dataSet, '2') && ~strcmp(dataSet, '3') && ...
    ~strcmp(dataSet, 'T1') && ~strcmp(dataSet, 'T2')
    error('ml_getPedestrianData.m: unkown option, dataSet must be either "1", "2", "3", "T1" or "T2"');
end;

if strcmp(dataType, 'positive') 
    imageDir = sprintf('%s\\%s\\ped_examples\\', DIR, dataSet);
elseif strcmp(dataType, 'negative')
    imageDir = sprintf('%s\\%s\\non-ped_examples\\', DIR, dataSet);
else
    error('ml_getPedestrianData.m: unkown option, dataType must be either "positive" or "negative"');
end;

files = ls([imageDir '*.pgm']);
nFiles = size(files,1);
if strcmp(mode, 'indexes')
    idxs = kk;
elseif strcmp(mode, 'all')
    idxs = 1:nFiles;
elseif strcmp(mode, 'random')
    randIdxs = randperm(nFiles);
    idxs = randIdxs(1:kk);
else
    error('ml_getPedestrianData.m: unkown option, mode must be either "all", "random" or "indexes"');
end;


D = zeros(648, length(idxs));        
if shldDisp
    fprintf('ml_getPedestrianData.m: reading image 00000/00000');
end;
for i=1:length(idxs)
    if shldDisp
        fprintf('\b\b\b\b\b\b\b\b\b\b\b%.5d/%.5d', i, length(idxs));
    end;
    fileName = [imageDir files(idxs(i),:)];
    image = imread(fileName, 'pgm');
    D(:,i) = image(:);
end
if shldDisp
    fprintf(' Done\n');
end;
D = double(D);