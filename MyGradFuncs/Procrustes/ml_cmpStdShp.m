function stdShp = ml_cmpStdShp(LmPts)
% function stdShp = ml_cmpStdShp(LmPts)
% Compute the standard shape for 2D shapes. This is part of the 
% procrustes analysis. In Procrustes analysis, the mean shape might
% not be the best standardized shape.
% This function first center each individual shape, normalize for the scale
% and then compute the mean shape.
% Inputs:
%   LmPts: a (2*k)*n matrix. k is the number of landmark points, each
%       landmark is a 2D coordinates. For each column, 
%       the first k entries are X coordinates, and the last are Y coords.
% Outputs:
%   stdShp: the standardized shape.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 28 Sep 2008

d = size(LmPts, 1);
k = d/2; % number of points

LmPts_X = LmPts(1:k, :);
LmPts_Y = LmPts(k+1:d,:);

mX = mean(LmPts_X);
vX = var(LmPts_X);
mY = mean(LmPts_Y,1);
vY = var(LmPts_Y);
v = sqrt(vX + vY); %scale factor is the std.

LmPts = LmPts - [repmat(mX, k, 1); repmat(mY,k,1)];
LmPts = LmPts./repmat(v, d, 1);
stdShp = mean(LmPts,2);



