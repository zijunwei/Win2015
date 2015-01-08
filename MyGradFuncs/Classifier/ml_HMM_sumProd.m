function [alphas, betas] = ml_HMM_sumProd(Os, X1CPT, XtCPT, OtCPT)
% function ml_HMM_sumProd(Os, X1CPT, XtCPT, OtCPT)
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
%   alphas: a m*n matrix, alphas(:,i): accumulate messages from X(i-1) and Oi to node Xi.
%   betas: a m*n matrix, betas(:,i) : accumulate messages from X(i+1) to node Xi.
%       Marginal probability of node Xi take value k and observing Os is alphas(k,i)*betas(k,i);
% By: Minh Hoai Nguyen
% Date: 6 Oct 2007.

m = size(XtCPT, 1); % total number of states.
n = length(Os); % length of the sequence.

% forward backward algorithm
% alphas(:,i): accumulate messages from the left and bottom to node i.
% betas(:,i) : accumulate messages from the right to node i.
% marginal probability of node i take value k is alphas(k,i)*betas(k,i);

% forward pass
alphas = zeros(m, n);
if Os(1) == -1
    alphas(:,1) = X1CPT;
else
    alphas(:,1) = X1CPT.*OtCPT(Os(1),:)';
end;

for i = 2:n
    if Os(i) == -1 % if Os(i) is not observed.
        alphas(:,i) = XtCPT*alphas(:,i-1);
    else
        alphas(:,i) = (XtCPT*alphas(:,i-1)).*OtCPT(Os(i),:)';
    end;
end;

% backward pass
betas = zeros(m, n);
betas(:,n) = ones(m, 1);

for i=n-1:-1:1
    if Os(i) == -1
        betas(:,i) = XtCPT'*betas(:,i+1);
    else
        betas(:,i) = XtCPT'*(betas(:,i+1).*OtCPT(Os(i+1),:)');
    end;
end;
