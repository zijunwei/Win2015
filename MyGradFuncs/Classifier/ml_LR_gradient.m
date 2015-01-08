function [w0, w] = ml_LR_gradient(trainData, trainLabel, nMaxIter, eta, tol)
% [w0, w] = ml_LR_gradient(trainData, trainLabel, nMaxIter, eta, tol)
% Perform logistic regression classifier, parameters are optimized using gradient ascent.
% Inputs:
%   trainData: training data in column format.
%   trainLabel: a column vector of 1 or 0 indicating the class of corresponding training data.
%       Note in LR, the probability P(class=1|x) = exp(w0+w'*x)/(1+exp(w0 + w'*x));
%       and P(class = 0|x) = 1/(1+exp(w0+w'*x);
%   nMaxIter: maximum number of iteration, default is 5000
%   eta: learning rate for gradient ascent optimization, default 0.001
%   tol: stopping condition, default: 0.001
% Output:
%   w0, w: the weights for attributes as described above.
% Other notes: See also ml_LR_IRLS.m others/m_test_LR.m
% By: Minh Hoai Nguyen
% Date: 5 Aug 2007.

if ~exist('nMaxIter', 'var') || isempty(nMaxIter)
    nMaxIter = 5000;
end;
if ~exist('eta', 'var') || isempty(eta)
    eta = 0.001; 
end;

if ~exist('tol', 'var') || isempty(tol)
    tol = 10^-3;
end;

[d,n] = size(trainData);

X = ones(d+1,n);
X(2:end,:) = trainData;
y = trainLabel;

Xy = X*y;
w = rand(d + 1, 1);

for i=1:nMaxIter
    a = exp(w'*X);
    prob = a./(1 + a);
    
    % Sometimes some entries of w'*X are very big, say 1000, exp(1000) = inf
    % If that happens, some entries of prob become NaN. However, if some entries of a
    % are Inf then the corresponding entries in prob should be 1 instead.
    prob(isnan(prob)) = 1;
    
    dw = Xy - X*prob';
    if sqrt(sumsqr(dw)/(d+1)) <tol
        break;
    end;
    if (sum(isnan(dw)))
        keyboard;
    end;
    w = w + eta*dw;
end;
fprintf('ml_LR_gradient, #iters: %d\n', i);
w0 = w(1);
w = w(2:end);
     