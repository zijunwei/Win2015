function [Data, label] = ml_getLetterData()
% function [Data, label] = ml_getLetterData()
% Load the Letter Data
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 24 Oct 2010

    oriDataFile = '/Users/hoai/DataSets/Letters/letter-recognition.data';
    storedDataFile = '/Users/hoai/DataSets/Letters/letter-recognition.mat';
    if ~exist(storedDataFile, 'file')
        [Data, label] = preProcess(oriDataFile);
        save(storedDataFile, 'Data', 'label');
    else
        load(storedDataFile, 'Data', 'label');
    end;
    
function [Data, label] = preProcess(fName)
    fid = fopen(fName, 'r');
    Data = zeros(16, 20000);
    label = zeros(1, 20000);
    cnt = 0;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end;
        cnt = cnt + 1;
        tline = strtrim(tline);  
        class = tline(1);
        attrs = sscanf(tline(3:end), '%f,');
        Data(:,cnt) = attrs;
        label(cnt) = class - 'A' + 1;
    end
    fclose(fid);
    Data = Data(:, 1:cnt);
    label = label(1:cnt);
    