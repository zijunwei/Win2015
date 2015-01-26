clear;
% this script runs the 4 most fundamental experiments 
% 1. no_thread fv+linear svm
% 2. no_thread fv+ lssvm
% 3. thread fv   + linear svm
% 4. thread fv   + lssvm
% select different mat file 
%load('hollywood2_fv_thread_l2.mat');
%load('/Users/zijunwei/Dropbox/HollywoodData/hollywood2.mat')
addpath_recurse('./MyGradFuncs');
addpath('~/Dev/MatlabLibs/libsvm/matlab/');

% case 1 kersvm
%aps=kerSVM(100,trD',trLb,tstD',tstLb,Lb_sets);
% case 2 lssvm
aps=kerLSSVM

