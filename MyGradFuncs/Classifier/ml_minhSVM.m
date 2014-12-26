function [v, b, weights, activeFeatIdxs, activeFeatWeights] = ml_minhSVM(NData, label, C, shldDisp)
% function [v, b] = ml_minhSVM(Data, label, C)
% Learning the weights for linear SVM
% This function tries to balance the size of two classes. 
% This function also balances between C and # of constraints; thus
% even the number of samples increase, the C can be kept constant. 
%
% Inputs:
%   NData: data matrix of size d*n, d: # features, n: # training data.
%   label: corresponding labels of training data, this is column vector.
%       the entries must be either 1 or -1.
%   C: the parameter C of linear SVM.
%   shldDisp: should display the training error?
% Outputs:
%   v: weight vector for SVM.
%   b: the b of the SVM.
%   weights: weights for the features.
%   activeFeatIdxs: indexes of active features (chosen, corresponding to
%       non-zero weights)
%   activeFeatWeights: weights of active features
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 29 Nov 2008


% NOISY_THRES = 1e-2; % for MNIST, linear kernel
% NOISY_THRES = 1e-6; % for MNIST, kernel

% remove noisy (or rather constant) features
% constThres = NOISY_THRES;
vars = var(NData, 0, 2);
constThres = median(vars)*0.01;
nonnoisyIdxs = vars > constThres;
Data = NData(nonnoisyIdxs, :);
nonnoisyIdxs = find(nonnoisyIdxs);

[d, n] = size(Data);
nPos = sum(label ==  1);
nNeg = sum(label == -1);

a1 = var(Data(:,label ==  1), 0, 2);
a2 = var(Data(:,label == -1), 0, 2);
a = a1 + a2;
a = a/sum(a);

% normalization factors for the weights.
normCoeffs = sqrt(a);
normCoeffs(normCoeffs < eps) = 0; % too small, for numerical stability

% weights for constraints
constrW = zeros(n, 1);
constrW(label == 1)  = 1/nPos;
constrW(label == -1) = 1/nNeg;

LabelData = repmat(label', d, 1).*Data;

% testSpeed(LabelData, label, a, normCoeffs, constrW, C); 
[v, b, weights] = optEngine3(LabelData, label, a, constrW, C);


maxAbsD = max(abs(Data), [], 2);

% Note
% % activeFeatIdxs = find(weights.*maxAbsD > (1e-3)/n); % Do not use this
% The reason is: if p_i = 0, v_i must also be 0.
% The oposite is not necessary true. There is a case where
% v_i = 0 but p_i could be anything. It is because normCoeffs_i = 0.
% So, it is better to use v to find the "active" indexes instead of using
% weights or p.

% activeFeatIdxs = find(weights.*maxAbsD > (1e-3)/n); % Do not use this
% activeFeatIdxs = find(abs(v).*maxAbsD > (1e-3)/n); % can be used
activeFeatIdxs = find(abs(v).*maxAbsD > 1e-5); % can be used
activeFeatWeights = weights(activeFeatIdxs);

% active feature relative to noisy indxes
activeFeatIdxs = nonnoisyIdxs(activeFeatIdxs);
    
if exist('shldDisp', 'var') && shldDisp
    svmScore = v'*Data + b;
    fprintf('  true positive rate: %.2f\n', sum(svmScore(label == 1) > 0)/nPos);
    fprintf('  true negative rate: %.2f\n', sum(svmScore(label ==-1) < 0)/nNeg);
    fprintf('  Number of non-zero weights: %d\n', length(activeFeatWeights));
end;



% Optimization using linear 
function [v, b, weights] = optEngine1(LabelData, label, normCoeffs, constrW, C)
    [d, n] = size(LabelData);
    cvx_precision high;
    cvx_begin
        variable v(d);
        variable xi(n);
        variable b;
    %     minimize( square_pos(sum(normCoeffs'*abs(v))) + C*(constrW'*xi));
        minimize(0.5*normCoeffs'*abs(v) + C*(constrW'*xi));
        subject to
            LabelData'*v + b*label + xi >= 1;
            xi >= 0;
    cvx_end

    if strcmp(cvx_status, 'Failed')
        error('ml_minhSVM: CVX failed to optimize. I dont know what to do.');
    end;

    alpha = normCoeffs'*abs(v);
    p = abs(v)./(eps + normCoeffs*alpha);
    weights = sqrt(p);

% Optimization using quadratic form
function [v, b, weights] = optEngine2(LabelData, label, normCoeffs, constrW, C)
    [d, n] = size(LabelData);
    cvx_precision high;
    cvx_begin
        variable v(d);
        variable xi(n);
        variable b;
        minimize(0.5*square_pos(normCoeffs'*abs(v)) + C*(constrW'*xi));
        subject to
            LabelData'*v + b*label + xi >= 1;
            xi >= 0;
    cvx_end

    if strcmp(cvx_status, 'Failed')
        error('ml_minhSVM: CVX failed to optimize. I dont know what to do.');
    end;

    alpha = normCoeffs'*abs(v);
    p = abs(v)./(eps + normCoeffs*alpha);
    weights = sqrt(p);

% optimization using quadratic over linear
function [v, b, weights] = optEngine3(LabelData, label, a, constrW, C)
    [d, n] = size(LabelData);
    %lb = eps*ones(d,1);
    ub = 1000*ones(d,1);
    
    cvx_precision high;
    cvx_begin
        variable v(d);
        variable p(d);
        variable xi(n);
        variable b;
        minimize(0.5*sum(quad_over_lin(v, p, 2)) + C*(constrW'*xi));
        subject to
            LabelData'*v + b*label + xi >= ones(n, 1);
            a'*p == 1;
            xi >= zeros(n,1);
            %p >= lb;
            p <= ub;
    cvx_end
    if strcmp(cvx_status, 'Failed')
        error('ml_minhSVM: CVX failed to optimize. I dont know what to do.');
    end;
 
    weights = sqrt(p);

function testSpeed(LabelData, label, a, normCoeffs, constrW, C) 
    % Three methods produce the same results.
    % Tested for C = 0.25
    % slowest method, took 217s, this optimization fails quite often.
    tic;
    [v2, b2, weights2] = optEngine2(LabelData, label, normCoeffs, constrW, C);
    toc;
    
    % fastest method, took 90s.
    tic;
    [v3, b3, weights3] = optEngine3(LabelData, label, a, constrW, C);
    toc;

    % For this method, C must be adjusted to have similar results.
    % This took 197s.
    C = C/(2*normCoeffs'*abs(v3));
    tic;
    [v1, b1, weights1] = optEngine1(LabelData, label, normCoeffs, constrW, C);
    toc;
    
    % display
    maxAbsD = max(abs(LabelData), [], 2);
    thres = 1e-5; 
    idxs1 = abs(v1).*maxAbsD > thres; 
    idxs2 = abs(v2).*maxAbsD > thres; 
    idxs3 = abs(v3).*maxAbsD > thres;
    w1 = weights1(idxs1);
    w2 = weights2(idxs2);
    w3 = weights3(idxs3);
   
    
    fprintf('# of active features, opt1: %d, opt2: %d, opt3: %d\n', ...
                sum(idxs1), sum(idxs2), sum(idxs3));
    fprintf('difference bt 1 and 2, idxs: %g, weight: %g\n', ...
        sum(abs(idxs1 - idxs2)), sum(abs(w1 - w2)));
    fprintf('difference bt 1 and 3, idxs: %g, weight: %g\n', ...
        sum(abs(idxs1 - idxs3)), sum(abs(w1 - w3)));
    fprintf('difference bt 2 and 3, idxs: %g, weight: %g\n', ...
        sum(abs(idxs3 - idxs2)), sum(abs(w2 - w3)));
    
            
    
    