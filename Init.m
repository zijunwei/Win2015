% run EVERYTIME starting Matlab
clear;
run('../ZFunc/Zj_Setup.m');
Zj_SetEnv.AddpathRecursive('./MyGradFuncs');
Zj_SetEnv.AddpathRecursive('./voc-release5');
run('./vlfeat/toolbox/vl_setup.m');

% add data folder path:

addpath('./DataActionMat/');
addpath('./DataUseful/')
classTxt = {'AnswerPhone', 'DriveCar', 'Eat', 'FightPerson', 'GetOutCar', 'HandShake', ...
    'HugPerson', 'Kiss', 'Run', 'SitDown', 'SitUp', 'StandUp'};