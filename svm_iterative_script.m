% clear;

%iteratively train svm and test results
% on single action calssifer
addpath_recurse('./MyGradFuncs');
addpath('~/Dev/MatlabLibs/libsvm/matlab/');

if ~exist('trD','var')
    %load testing data from hollywood 2 thread
    load('hollywood2_fv_thread.mat');
    
    %load training data
    load('training_fv_t.mat');
    trD=fv_t;
    fprintf('training data loaded')
    % load training label
    load('training_lbs.mat')
    trLb=Lb_all;
    % %load testing data
    % load('testing_fv_t.mat');
    % fprintf('testing data loaded')
    % tstD=fv_t;
    % load('testing_lbs.mat');
    % tstLb=Lb_all;
end

trK = trD*trD';
tstK = tstD*trD';
nAction = length(Lb_sets);

for i=1:1:nAction
    
    trLb_i=trLb(i,:);
    tstLb_i=tstLb(i,:);
    Lambda=1e-6;
    ap(i)=singleKerLSSVM_iterative(Lambda,trK,trLb_i,tstK,tstLb_i,20);
end

for i=1:nAction
    cls = Lb_sets{i};
    fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*ap(i));
end
fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(ap));