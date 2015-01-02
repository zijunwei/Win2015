clear;

% select different mat file 
load('/Users/zijunwei/Dropbox/HollywoodData/hollywood2_fv_thread.mat');
%load('/Users/zijunwei/Dropbox/HollywoodData/hollywood2.mat')
addpath_recurse('./MyGradFuncs');
addpath('~/Dev/MatlabLibs/libsvm/matlab/');

% case 1 kersvm
%aps=kerSVM(100,trD',trLb,tstD',tstLb,Lb_sets);
% case 2 lssvm
aps=kerLSSVM(1e-3,trD',trLb,tstD',tstLb,Lb_sets);

