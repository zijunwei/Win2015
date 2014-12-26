function ml_writeAscii(fileName, mode, data)
% ml_writeAscii(fileName, M, mode)
% Write the numerical matrix M to a file in Ascii mode as decimal numbers. 
% Note: you can use the 'save' command of Matlab with '-ascii' option
% but it write numbers not in the decimal formats which are very hard for
% C/C++ input stream to parse. 
% For example, if M = [1, 2], 'save(fileName, 'M', '-ascii') 
% write in the file as: 1.0000000e+02 2.0000000e+02
% which cannot be loaded easily by C/C++ input stream.
%
% Inputs:
%   fileName: name of the file to write
%   mode: 'w' for write and 'a' for append.
%   data: 1*k cell array of matrices.
% Outputs:
%   Data written in fileName.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 13 Oct 09

fid = fopen(fileName, mode);
for i=1:length(data)
    fprintf(fid, [repmat('%g ', 1, size(data{i},2)), '\n'], data{i}');
end;
fclose(fid);
