function refShp = ml_cmpStdShp_v2(Data)
% function refShp = ml_cmpStdShp_v2(Data)
% Compute the reference (stand shape) for data.
% This function is part of Procrustes Analysis version 2.
% In Procrustes analysis, the mean shape might
% not be the best standardized shape.
% This function has four steps:
%   1. Center each individual shape, normalize for the scale
%   2. Take the mean shape as the first reference shape. 
%   3. Find a shape that best matches the mean shape.
%   4. Repeat 2 times:
%       4a. Align each shape to the current reference shape by removing 
%           translation, reflection, orthogonal rotation, and scaling.
%       4b. Take the reference shape as the new mean.
%
% Inputs:
%   Data: k*d*n
%       k: number of point per shape
%       d: number of dimension of each point (d = 2 for 2D, 3 for 3D points)
%       n: number of shapes.
% Outputs:
%   refShp: k*d matrix for the reference shape.
% See Also: ml_procrustes_helper_v2.
%   Compared with ml_cmpStdShp.m, this function is newer,
%   and it handles multiple dimensional points.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 10 Jul 2009

[k,d,n] = size(Data);


% first step, center data and remove scale
Data = permute(Data, [2, 3, 1]);
Data = Data - repmat(mean(Data, 3), [1,1,k]); % center data
Data_var = var(Data, [], 3); % variance
scls = sqrt(sum(Data_var));     % scale for each point
scls = scls/median(scls(:));

Data = Data./repmat(scls, [d, 1, k]);
Data = permute(Data, [3, 1, 2]);

% second step:
refShp = mean(Data, 3); % the first reference shape is the mean shape.

% third step:
errs = zeros(size(Data,3), 1);
DataAl = Data;
for i = 1:size(Data,3)
    [errs(i)  DataAl(:,:,i)] = procrustes(refShp, Data(:,:,i), 'reflection', 0);            
end
[dc, idx] = min(errs); % index of shape that best align with the mean shape
refShp = DataAl(:,:,idx);
    

% fourth step
for iter = 1:2
    cumErr = 0;
    for i = 1:size(Data,3)
        [err DataAl(:,:,i)] = procrustes(refShp, Data(:,:,i), 'reflection', 0);            

        cumErr = cumErr + err;
    end
    refShp = mean(DataAl,3);
    fprintf('Iteration %d. Error: %.3f\n', iter, cumErr);
end
