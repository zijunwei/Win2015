function [a, c, algnShp] = ml_nrShpAlgn(shp, mShp, B, W, lambdas)
% function [a, c] = ml_nrShpAlgn(shp, mShp, B, W)
% non-rigid alignment of shape to a mean shape and the subspace
% The error function this function minimizes is:
% ||W.*(shp - AffineWar(mShp + B*c, a))||^2
% The error measurement is in the original image space.
% Inputs:
%   shp: the shape we want to register
%       This is 2k*1 matrix for k 2D-landmark points.
%   mShp: mean shape, this is 2k*1 vector.
%   B: basis for shape variation. This is 2k*m matrix.
%   W: weights for different landmarks. This is k*1 vector for weights
%       of different landmarks.
% Outputs:
%   a: affine params
%   c: non-rigid params
% By: Minh Hoai Nguyen
% Date: 18 Oct 2008

MAX_ITER = 10; % 10 is good enough, tested.
% apply the weights.
W = repmat(W,2,1);
shp_w = W.*shp;
mShp_w = W.*mShp;
B_w = B.*repmat(W, 1, size(B,2));
ub = 3*sqrt(lambdas);
lb = -ub;

mShp_w2 = mShp_w;
for iter=1:MAX_ITER
    a = ml_procrustes_helper(mShp_w2, shp_w);        
    mShp_wrp = ml_affShpWrp(mShp_w, a);
    a2 = a;
    a2([3,6]) = 0; % no translation in the warp param of basis
    B_wrp = ml_affShpWrp(B_w, a2); 
    c = B_wrp\(shp_w - mShp_wrp);
    c = min(c, ub);
    c = max(c, lb);
    mShp_w2 = mShp_w + B_w*c;
    algnShp = ml_affShpWrp(mShp + B*c, a);
%     fprintf('ml_nrShpAlgn: iter %d, error: %g\n', iter, sumsqr(algnShp - shp));
end;

