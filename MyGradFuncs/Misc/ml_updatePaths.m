function ml_updatePaths()

    % Update MatlabLib Function
    if strcmp(computer('arch'), 'win32')
       studyDir = 'D:\Study\';
       addpath('D:\Study\Libs\GoodLibs\qqinterp2/');
    elseif strcmp(computer('arch'), 'maci')
        studyDir = '/Users/hoai/Study/';        
    else
        studyDir = '/cv/minhhoan/Study/';
        addpath(sprintf('%s/Libs/vlfeat-0.9.9/toolbox/misc/', studyDir));
        addpath(sprintf('%s/Libs/vlfeat-0.9.9/toolbox/mex/mexa64/', studyDir));
        addpath(sprintf('%s/Libs/LibSVM/libsvm-mat-3.0-1/', studyDir));
        addpath(sprintf('%s/Libs/cvx/builtins/', studyDir));
        addpath(sprintf('%s/Libs/cvx/commands', studyDir));
        addpath(sprintf('%s/Libs/cvx/functions', studyDir));    
        addpath(sprintf('%s/Libs/cvx/lib', studyDir));
        addpath(sprintf('%s/Libs/cvx/structures', studyDir));
        addpath(sprintf('%s/Libs/cvx', studyDir));
        
        addpath(sprintf('%s/Projects/CplexMex/bin/', studyDir));
    end;

    % Add path from the Matlab libs
    baseDir = [studyDir, 'Libs/MyGradFuncs/'];
    subDirs = {'Alignment', 'ComponentAnalysis', 'Dijkstra', 'Features', 'Kmeans', ...
              'Pre-image', 'Classifier', 'Cosegment', 'DataAccess', 'Display', 'GraphCut', 'Misc'};
    for i=1:length(subDirs)
      addpath([baseDir subDirs{i}]);
    end
    
    addpath(sprintf('%s/Libs/Hungarian_Algorithm/', studyDir));
    
    % Add the cosegmentation path
    addpath([studyDir, '/Projects/BeyondSlideWin/mexBin']);
    addpath([studyDir, '/Projects/BeyondSlideWin/mexSrc']);
    addpath([studyDir, '/Projects/SOSVM/src']);
    
    %savepath;

