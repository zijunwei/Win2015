function [Data, label] = ml_getGlassData()
% function [Data, label] = ml_getGlassData()
% Load the UCI Glass data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 8 Nov 2010

    oriDataFile = '/Volumes/Lacie/DataSets/Glass/glass.data';
    storedDataFile = '/Volumes/Lacie/DataSets/Glass/glass.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(fName)
    fid = fopen(fName, 'r');
    Data = zeros(11, 214);
    cnt = 0;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        cnt = cnt + 1;
        tline = strtrim(tline);  
        Data(:,cnt) = sscanf(tline(1:end), '%f,');
    end
    fclose(fid);
    Data = Data(:, 1:cnt);
    label = Data(end,:);
    Data = Data(2:end-1,:);
    
