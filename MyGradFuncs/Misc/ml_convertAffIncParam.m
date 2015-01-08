function newP = ml_convertAffIncParam(p, xc, yc)
% ml_convertAffIncParam(p, xc, yc)
% Affine transformation depend on the parameters and the coordinates used.
% This function transform affine INCREMENTAL param from face coordinates (e.g. center of the face)
% to the coordinates w.r.t to the image. 
% Inputs:
%   p: 6*1 affine incremental params.
%   xc, yc: center of the face coordinate.
% Outputs:
%   newP: 6*1 affine incremental params w.r.t the image coordinate.
% By Minh Hoai Nguyen
% Date: 20 Nov 07

newP = p;
newP([3,6]) = p([3,6]) - [p(1) p(2); p(4) p(5)]*[xc; yc];
