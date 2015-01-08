function [DataAl, T] = ml_procrustes_helper_v2(Data, refShp, lmPtIdxs)
% [DataAl, T] = ml_procrustes_helper_v2(Data, lmPtIdxs, refShp)
% This function align the shapes given in Data to the reference shape refShp
% The alignment is done by removing translation, reflection, orthogonal
% rotation, and scaling.
% Inputs:
%   Data: k*d*n
%       k: number of point per shape
%       d: number of dimension of each point (d = 2 for 2D, 3 for 3D points)
%       n: number of shapes.
%   refShp: k2*d matrix for the reference shape.
%   lmPtIdxs: k2*1 vector for the indexes of points used for alignment
% See Also: ml_cmpStdShp_v2.m. 
%   Compared with ml_procrustes_helper, this function is newer,
%   and it handles multiple dimensional points.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 10 Jul 2009

[k, d, n] = size(Data);
DataAl = Data;
T = cell(1, n);
for i = 1:n
    [err dc T{i}] = procrustes(refShp, Data(lmPtIdxs,:,i), 'reflection', 0);
    DataAl(:,:,i) = T{i}.b*Data(:,:,i)*T{i}.T + repmat(T{i}.c(1,:),k, 1);
end
