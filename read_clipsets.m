function [ C ] = read_clipsets( input_file )
%READ_CLIPSETS Summary of this function goes here
%   Detailed explanation goes here

fid = fopen(input_file);
C= textscan(fid,'%s%d');
fclose(fid);
C=cell2struct(C,{'fname','label'},2);
end

