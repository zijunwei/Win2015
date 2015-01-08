function [Data, label] = ml_getSegmentationData()
% function [Data, label] = ml_getSegmentationData()
% Load the UCI segmentation data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 8 Nov 2010

    oriDataFile = '/Users/hoai/DataSets/segmentation/segmentation.data';
    storedDataFile = '/Users/hoai/DataSets/segmentation/segmentation.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(fName)
    fid = fopen(fName, 'r');
    Data = zeros(19, 210);
    label = zeros(1, 210);
    
    cnt = 0;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        tline = strtrim(tline);    
        [class, tline] = strtok(tline, ',');
        attrs = sscanf(tline, ',%f');
        cnt = cnt+1;
        Data(:,cnt) = attrs;
        
        if strcmpi(class, 'BRICKFACE')
            label(cnt) = 1;
        elseif strcmpi(class, 'SKY')
            label(cnt) = 2;
        elseif strcmpi(class, 'FOLIAGE')
            label(cnt) = 3;
        elseif strcmpi(class, 'CEMENT')
            label(cnt) = 4;
        elseif strcmpi(class, 'WINDOW')
            label(cnt) = 5;
        elseif strcmpi(class, 'PATH')
            label(cnt) = 6;
        elseif strcmpi(class, 'GRASS')
            label(cnt) = 7;
        end;
    end
    fclose(fid);
    Data = Data(:,1:cnt);
    label = label(1:cnt);
    label = label(:);
    