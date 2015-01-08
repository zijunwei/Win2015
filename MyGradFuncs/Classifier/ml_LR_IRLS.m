function [w0, w] = ml_LR_IRLS(trainData, trainLabel, nMaxIter, tol, shldDisp)
% [w0, w] = ml_LR_IRLS(trainData, trainLabel, nMaxIter, tol, shldDisp)
% Perform logistic regression classifier, parameters are optimized using Iteratively Reweighted Least Square.
% Inputs:
%   trainData: training data in column format.
%   trainLabel: a column vector of 1 or 0 indicating the class of corresponding training data.
%       Note in LR, the probability P(class=1|x) = exp(w0+w'*x)/(1+exp(w0 + w'*x));
%       and P(class = 0|x) = 1/(1+exp(w0+w'*x);
%   nMaxIter: maximum number of iteration, default is 200
%   tol: stopping condition, default: 1e-10
% Output:
%   w0, w: the weights for attributes as described above.
% Other notes: See also ml_LR_gradient.m others/m_test_LR.m
%   The core part of this function was originally implemented by Geoff Gordon.
% By: Minh Hoai Nguyen
% Date: 5 Aug 2007.
    
if ~exist('nMaxIter', 'var') || isempty(nMaxIter)
    nMaxIter = 200;
end;

if ~exist('tol', 'var') || isempty(tol)
    tol = 1e-10;
end;

if ~exist('shldDisp') || isempty(shldDisp)
    shldDisp = 0;
end;


[d,n] = size(trainData);

X = ones(d+1,n);
X(2:end,:) = trainData;
y = trainLabel;

w = logistic(X', y, [], nMaxIter, tol, shldDisp);
w0 = w(1);
w = w(2:end);

% This function is downloaded from Geoff Gordon's website on 5 Aug 2007
% http://www.cs.cmu.edu/~ggordon/IRLS-example/
% This is probably written by Geoff Gordon. 
% Logistic regression.  Design matrix A, targets Y, optional
% instance weights W.  Model is E(Y) = 1 ./ (1+exp(-A*X)).
% Outputs are regression coefficients X.
% Some part of function has been modified by Minh Hoai Nguyen
function x = logistic(a, y, w, maxiter, epsilon, shldDisp)
    ridge = 1e-5;
    [n, m] = size(a);
    
    if ~exist('w', 'var') || isempty(w) 
      w = ones(n, 1);
    end

    x = zeros(m,1);
    oldexpy = -ones(size(y));
    for iter = 1:maxiter
        adjy = a * x;
        expy = 1 ./ (1 + exp(-adjy));
        deriv = max(epsilon*0.001, expy .* (1-expy));
        adjy = adjy + (y-expy) ./ deriv;
        weights = spdiags(deriv .* w, 0, n, n);

        x = inv(a' * weights * a + ridge*speye(m)) * a' * weights * adjy;

        if shldDisp
            fprintf('%3d: [',iter);
            fprintf(' %g', x);
            fprintf(' ]\n');
        end;
        if (sum(abs(expy-oldexpy)) < n*epsilon)            
            break;
        end
        oldexpy = expy;
    end
    fprintf('ml_LR_IRLS.m: #iters: %d\n', iter);
