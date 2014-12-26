function [Data, label] = ml_getIonosphereData()
% function [Data, label] = ml_getIonosphereData()
% Load the Ionosphere Data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 20 Mar 08

    oriDataFile = '/Volumes/Lacie/DataSets/Inonosphere/ionosphere.data';
    storedDataFile = '/Volumes/Lacie/DataSets/Inonosphere/ionosphere.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(oriDataFile)
    fName = 'D:\Study\DataSets\Inonosphere\ionosphere.data';
    fid = fopen(fName, 'r');
    gIndex = 0;
    bIndex = 0;
    gData = zeros(34,1);
    bData = zeros(34,1);
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        tline = strtrim(tline);    
        attrs = sscanf(tline, '%f,');
        class = tline(1,end);
        if (class(1) == 'g')
            gIndex = gIndex + 1;
            gData(:,gIndex) = attrs;
        elseif (class(1) == 'b')
            bIndex = bIndex + 1;
            bData(:,bIndex) = attrs;
        end;
    end
    fclose(fid);
    Data = [gData, bData];
    label = [ones(size(gData,2),1); -ones(size(bData,2),1)];
    