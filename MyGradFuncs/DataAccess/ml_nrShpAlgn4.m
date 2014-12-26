function [a, c, algnShp] = ml_nrShpAlgn4(shp, mShp, B, W, lambdas, gamma)
% function [a, c, algnShp] = ml_nrShpAlgn4(shp, mShp, B, W, lambdas, gamma)
% non-rigid alignment of shape to a mean shape and the subspace
% The error function this function minimizes is:
% ||W.*(AffineWarp(shp, inv(a))  - mShp - B*c)) - w||_2^2 + gamma*||W.^2.*w||_1
% The error measurement is in the space of basis, not the original space.
% This function provides ROBUST estimation.
% This function is not iterative.
% Inputs:
%   shp: the shape we want to register
%       This is 2k*1 matrix for k 2D-landmark points.
%   mShp: mean shape, this is 2k*1 vector.
%   B: basis for shape variation. This is 2k*m matrix.
%   W: weights for different landmarks. This is k*1 vector for weights
%       of different landmarks.
%   lambdas: eigenvalues for shape variations.
%   gamma: tradeoff coefficient for sparseness of vector w.
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

m = double(mShp); % mean vector
M = double([M, -B]);

sqrW = W.^2;

M1 = M(1:nLmPt,:);
M2 = M(nLmPt+1:end,:);
m1 = m(1:nLmPt);
m2 = m(1+nLmPt:end);

cvx_begin
    variable x(6+size(B,2));
    variable w(nLmPt);
    minimize(sum(sqrW.*square(M1*x - m1 - w)) + sum(sqrW.*square(M2*x - m2 - w))+...
        gamma*norm(sqrW.*w,1) + 0.0005*sum(square(x(7:end))./lambdas));
%     subject to
%         x(7:end) >= -3*sqrt(lambdas);
%         x(7:end) <=  3*sqrt(lambdas);
cvx_end


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


