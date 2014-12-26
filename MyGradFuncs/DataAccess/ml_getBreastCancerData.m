function [Data, label] = ml_getBreastCancerData()
% function [Data, label] = ml_getBreastCancerData()
% Load the Breast Cancer Data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 20 Mar 08

    oriDataFile = '/Volumes/Lacie/DataSets/Breast Cancer/wdbc.data';
    storedDataFile = '/Volumes/Lacie/DataSets/Breast Cancer/wdbc.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(oriDataFile)
    fid = fopen(oriDataFile, 'r');
    mIndex = 0;
    bIndex = 0;
    mData = zeros(30,1);
    bData = zeros(30,1);
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        tline = strtrim(tline);    
        commaPos = findstr(tline, ',');
        class = tline(commaPos(1) + 1);
        attrs = sscanf(tline((commaPos(1)+2):end),',%f');
        if (class == 'M')
            mIndex = mIndex + 1;
            mData(:,mIndex) = attrs;
        elseif (class == 'B')
            bIndex = bIndex + 1;
            bData(:,bIndex) = attrs;
        end;
    end
    fclose(fid);    
    Data = [mData, bData];
    label = [ones(size(mData,2),1); -ones(size(bData,2),1)];
    