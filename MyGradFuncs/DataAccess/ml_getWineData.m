function [Data, label] = ml_getWineData()
% function [Data, label] = ml_getWineData()
% Load the UCI wine data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 8 Nov 2010

    oriDataFile = '/Volumes/LaCie/DataSets/wine/wine.data';
    storedDataFile = '/Volumes/LaCie/DataSets/wine/wine.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(fName)
    fid = fopen(fName, 'r');
    Data  = zeros(13, 178);
    label = zeros(1, 178);
    
    cnt = 0;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        tline = strtrim(tline);    
        attrs = sscanf(tline, '%f,');
        
        cnt = cnt+1;
        Data(:,cnt) = attrs(2:end);
        label(cnt) = attrs(1);
    end
    fclose(fid);
    Data = Data(:,1:cnt);
    label = label(1:cnt);
    label = label(:);
    
    