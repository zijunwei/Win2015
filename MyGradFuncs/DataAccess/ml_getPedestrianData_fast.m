function D = ml_getPedestrianData_fast(dataSet, dataType, mode, kk)
% D = ml_getPedestrianData_fast(dataSet, dataType, mode, kk)
% Get pedestrian data from cached files of preloaded images. This method
% is faster than ml_getPedestrianData()
% Inputs:
%   dataSet: takes one of the following: '1', '2', '3', 'T1', or 'T2' which are 5 different parts
%       of the database. Data from different parts are mutually exclusive.
%   dataType: either 'positive' or 'negative', set to 'positive' for positive examples.
%   mode: either 'all', 'random', or 'indexes'. If mode is 'all', all positive or negative of the 
%       the specified data part are retrived. If mode is 'indexes', retrieve examples with indexes
%       specified in kk. If mode is 'random', retrieve kk randome examples.
%   kk: See explanation for mode.
% Outputs:
%   D: data in column format.
% Other Notes: see also ml_getPedestrianData.m
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 14 August 2007

DIR = 'D:\Study\DataSets\Pedestrian\DC-ped-dataset_base\caches\';

if ~strcmp(dataSet, '1') && ~strcmp(dataSet, '2') && ~strcmp(dataSet, '3') && ...
    ~strcmp(dataSet, 'T1') && ~strcmp(dataSet, 'T2')
    error('ml_getPedestrianData_fast.m: unkown option, dataSet must be either "1", "2", "3", "T1" or "T2"');
end;

if strcmp(dataType, 'positive') 
    imageFile = [DIR dataSet '_Pos.mat']; 
elseif strcmp(dataType, 'negative')
    imageFile = [DIR dataSet '_Neg.mat'];
else
    error('ml_getPedestrianData_fast.m: unkown option, dataType must be either "positive" or "negative"');
end;

load(imageFile, 'D');
nFiles = size(D,2);

if strcmp(mode, 'indexes')
    idxs = kk;
elseif strcmp(mode, 'all')
    idxs = 1:nFiles;
elseif strcmp(mode, 'random')
    randIdxs = randperm(nFiles);
    idxs = randIdxs(1:kk);
else
    error('ml_getPedestrianData_fast.m: unkown option, mode must be either "all", "random" or "indexes"');
end;
D = D(:, idxs);


function genCacheData()
    DIR = 'D:\Study\DataSets\Pedestrian\DC-ped-dataset_base\caches\';
    dataSets = {'1', '2', '3', 'T1', 'T2'};

    for i=1:length(dataSets)
        D = ml_getPedestrianData(dataSets{i}, 'positive', 'all', [], 1);
        save([DIR dataSets{i} '_Pos.mat'], 'D');
        D = ml_getPedestrianData(dataSets{i}, 'negative', 'all', [], 1);
        save([DIR dataSets{i} '_Neg.mat'], 'D');
    end;
    