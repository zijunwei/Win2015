function ml_addMocapLibPaths()

    % Update MatlabLib Function
    
    mocapLib = '/Libs/MocapTools/VideoDemo/';
    FengDemo = '/Libs/MocapTools/Feng_sample/';
    
    if strcmp(computer('arch'), 'win32')
       studyDir = 'D:\Study\';
    elseif strcmp(computer('arch'), 'maci')
        studyDir = '/Users/hoai/Study/'; 
    else
        studyDir = '/cv/minhhoan/Study/';
    end
    
    addpath([studyDir, mocapLib, '/lib/mocap/lib/option/']);
    addpath([studyDir, mocapLib, '/lib/mocap/lib/common/']);
    addpath([studyDir, mocapLib, '/lib/mocap/lib/position/']);
    addpath([studyDir, mocapLib, '/lib/mocap/lib/matlabfun/']);
    addpath([studyDir, mocapLib, '/lib/mocap/getdata/dof/']);
    addpath([studyDir, mocapLib, '/lib/mocap/animation/']);
    addpath([studyDir, FengDemo, '/segment/']);
    addpath([studyDir, FengDemo, '/lib/']);
    addpath([studyDir, FengDemo, '/toy_data/']);
    addpath([studyDir, FengDemo, '/show/']);
    