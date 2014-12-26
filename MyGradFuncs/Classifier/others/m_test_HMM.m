function m_test_HMM()    
% Numerical mapping of states: S=1,A=2,W=3;H=1,R=2;F=3
% 
% 
% trans_prob(i,j)(ith row, jth column) = P(C^{t+1}=j|C^{t}=i) for all t>=1
% 
% 0.8,0.18,0.02
% 0.15,0.7,0.15
% 0.25,0.05,0.7
% 
% emit_prob(i,j) = P(O^{t}=j|C^{t}=i)
% 
% 0.5, 0.45, 0.05
% 0.3, 0.4, 0.3
% 0.0001, 0.2499, 0.75

% Observation: R F F H F H H H H H H H H R H H H R H H

XtCPT = [0.8, 0.18, 0.02;  ...
         0.15, 0.7, 0.15; ...
         0.25, 0.05, 0.7]';
OtCPT = [0.5, 0.45, 0.05; ...
         0.3, 0.4, 0.3;   ...
         0.0001, 0.2499, 0.75]';
X1CPT = [1/3, 1/3, 1/3]';

%     R F F H F H H H H H H H H R H H H R H H
Os = [2 3 3 1 3 1 1 1 1 1 1 1 1 2 1 1 1 2 1 1]';

tryOs = Os;

[alphas, betas] = ml_HMM_sumProd(tryOs, X1CPT, XtCPT, OtCPT);
[maxValues, bestMarXs] = max(alphas.*betas, [], 1);
fprintf('Best marginal probability\n');
fprintf('%d ', bestMarXs); fprintf('\n');

bestJointXs = ml_HMM_maxProd(tryOs, X1CPT, XtCPT, OtCPT);
fprintf('Best joint probability\n');
fprintf('%d ', bestJointXs'); fprintf('\n');

%compute the probability of having winter:
a = alphas.*betas;
fprintf('Prob of winter: %g\n', a(3,end)./sum(a(:,end)));









