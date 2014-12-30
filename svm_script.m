clear;
load('hollywood2.mat');
addpath_recurse('./MyGradFuncs');
addpath('~/Dev/MatlabLibs/libsvm/matlab/');
aps=kerSVM(100,trD',trLb,tstD',tstLb,Lb_sets);