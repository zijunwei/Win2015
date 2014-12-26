function ml_dispMatrix(A, format)
% function ml_dispMatrix(A, format)
% Display a matrix in a formated way.
% Inputs:
%   A: the matrix to display.
%   format: the format of the fprintf which governs  how much space given to each number in the matrix. 
%       default value of 'format' is '%5.2f';
% Outputs:
%   No output, this print to the standard output.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 2 Nov 2007

if ~exist('format', 'var') || isempty(format)
    format = ('%5.2f');
end;
for i=1:size(A,1)
    fprintf(format, A(i,:));
    fprintf('\n');
end;
