function [a, c, algnShp] = ml_nrShpAlgn2(shp, mShp, B, W, lambdas)
% function [a, c, algnShp] = ml_nrShpAlgn(shp, mShp, B, W)
% non-rigid alignment of shape to a mean shape and the subspace
% The error function this function minimizes is:
% ||W.*(AffineWarp(shp, inv(a))  - mShp -  B*c))||^2
% The error measurement is in the space of basis, not the original space.
% This does not use iterative technique like ml_nrShpAlgn3
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
% See also: ml_nrShpAlgn, ml_nrShpAlgn3
% By: Minh Hoai Nguyen
% Date: 23 Oct 2008


nLmPt = length(shp)/2;
M = [shp(1:nLmPt), shp(1+nLmPt:end), ones(nLmPt,1)];
scls = sqrt(sum(M.^2)); % scales for x,y, 1 coordinates.

% scale columns of M to unit length, for consistence with scale of
% shape basis vectors
M = M./(repmat(scls + eps, size(M,1), 1));
M = [M, zeros(size(M)); zeros(size(M)), M];

m = mShp; % mean vector
M = [M, -B];

W = repmat(W, 2, 1);
WM = repmat(W, 1, size(M,2)).*M; % weighted 
Wm = W.*m;

% ub = [inf*ones(6,1);3*sqrt(lambdas)];
% lb = -ub;
% x = quadprog(double(WM'*WM), double(-Wm'*WM), [], [], [], [], lb, ub);

% x = WM\Wm;
% x = inv(WM'*WM)*WM'*Wm;
x = linsolve(WM, Wm);

%rescale x
a_inv = x(1:6)./repmat(scls'+eps,2,1);
c = x(7:end); % nonrigid shape coefficients
%constraining that shpCoeffs(i) < 3*sqrt(lambda_i)
c = min(c, 3*sqrt(lambdas));
c = max(c, -3*sqrt(lambdas));

rec = m + B*c;
rec = reshape(rec, nLmPt, 2);

tmp = inv([a_inv(1) a_inv(2); a_inv(4) a_inv(5)]);
a = zeros(6,1);
a([1 4 2 5]) = tmp(:);
a([3, 6]) = -tmp*[a_inv(3); a_inv(6)];

% algnShp = inv([a(1) a(2); a(4) a(5)])*...
%     (rec' - repmat([a(3); a(6)], 1, nLmPt));
algnShp = [a(1) a(2); a(4) a(5)]*rec' + repmat([a(3); a(6)], 1, nLmPt);
algnShp = algnShp';
algnShp = algnShp(:);


