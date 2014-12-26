function [bigImglist, bigLmlist] = ml_combineImLmLsts(imlmlistFiles, shldSort)
% function [bigImglist, bigLmlist] = ml_combineImLmLsts(imlmlistFiles)
% function [bigImglist, bigLmlist] = ml_combineImLmLsts(imlmlistFiles, shldSort)
% Load and combine several imlmlist files.
% Inputs:
%   imlmlistFiles: a cell structure contains names of imlmlist files.
%   shldSort: should we sort the list based on alphabetical order. Here, we
%   sort base on the short name of the files not the long names.
% Outputs:
%   bigImglist, bigLmlist: 2 cell structures containing names of img and
%   landmark files.
% By Minh Hoai Nguyen
% Date: 3 June 07.

if ~exist('shldSort', 'var') || isempty(shldSort)
    shldSort = 0;
end;

load(imlmlistFiles{1}, 'imglist', 'lmlist');
bigImglist = imglist;
bigLmlist = lmlist;
for i=2:length(imlmlistFiles)
    load(imlmlistFiles{i}, 'imglist', 'lmlist');
    n = length(imglist);
    bigImglist(1+end:n+end) = imglist;
    bigLmlist(1+end:n+end) = lmlist;
end;

if shldSort
    imgNames = cell(length(bigImglist),1);
    for i=1:length(bigImglist)
        imgNames{i} = ml_full2shortName(bigImglist{i});
    end;
    [junk, IX] = sort(imgNames);       
    bigImglist = bigImglist(IX);
    bigLmlist = bigLmlist(IX);
end;
