function bestXs = ml_HMM_maxProd(Os, X1CPT, XtCPT, OtCPT)
% function ml_HMM_maxProd(Os, X1CPT, XtCPT, OtCPT)
% Perform sum-product algorithm for HMM (forward-backward)
%
%   O1      O2              On
%   ^       ^               ^
%   |       |               |
%   |       |               |
%   X1 --> X2 --> .... --> Xn
% Notations:
%   m: the total number of states.
%   n: the length of the sequence.
%   k: the total number of different observable patterns.
% Inputs:
%   Os: the values of observed variables. This is a n*1 vector. Valid entries are from 1 to k or -1. 
%       Os(i) = -1 mean Oi is unobserved.
%   X1CPT: CPT of the first state P(X1), this is a m*1 vector.
%   XtCPT: CPT of state transition P(X(t+1)|Xt), this is a m*m matrix XtCPT(i,j) = P(State_i|State_j).
%   OtCPT: CPT of observed data and states P(Ot|Xt), this is a k*m matrix. OtCPT(i,j) = P(Pattern_i|State_j).
% Outputs:
%   bestXs: best explanation for Xs.   
% By: Minh Hoai Nguyen
% Date: 6 Oct 2007.

m = size(XtCPT, 1); % total number of states.
n = length(Os); % length of the sequence.


% forward pass
maxOtCPT = max(OtCPT, [], 1)';
alphas = zeros(m, n);
if Os(1) == -1
    alphas(:,1) = X1CPT.*maxOtCPT;
else
    alphas(:,1) = X1CPT.*OtCPT(Os(1),:)';
end;

for i = 2:n
    if Os(i) == -1 % if Os(i) is not observed.
        alphas(:,i) = max(XtCPT.*repmat(alphas(:,i-1)', m, 1), [], 2).*maxOtCPT;
    else
        alphas(:,i) = max(XtCPT.*repmat(alphas(:,i-1)', m, 1), [], 2).*OtCPT(Os(i),:)';
    end;
end;

    
% backward pass, compute best explanation.
bestXs = zeros(n,1);
[maxValue, bestXs(n)] = max(alphas(:,n));
for i=n-1:-1:1
    [maxValue, bestXs(i)] = max(alphas(:,i).*XtCPT(bestXs(i+1),:)');
end;


