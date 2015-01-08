function bigIm = ml_data2Img(data, h, w, nC, nR, mode)
% bigIm = m_data2Img(data, h, w, nC, nR)
% bigIm = m_data2Img(data, h, w)
%   turn a 2D matrix in which each column is a reshape image
%   back to a giant image. Images are concatenated into big image by
%   filling top rows then bottom ones.
% Inputs:
%   mode: 'color' or 'gray'
%   ws: size of white space
% By Minh Hoai Nguyen
% Last modified: 10 April 07

n = size(data,2);
if ~exist('nC', 'var') || ~exist('nR', 'var') || isempty(nC) || isempty(nR)
    nC = ceil(sqrt(n*h/w));
    nR = ceil(n/nC);
end
if exist('mode', 'var') && strcmp(mode, 'color')
    bigIm = zeros(nR*h, nC*w, 3);
    for i = 1:n;
        r = ceil(i/nC);
        c = mod(i-1, nC) + 1;        
        bigIm((1 + (r-1)*h):(r*h), (1+ (c-1)*w):(c*w), :) = reshape(data(:,i), h, w, 3);
    end; 
else
    bigIm = zeros(nR*h, nC*w);
    for i = 1:n;
        r = ceil(i/nC);
        c = mod(i-1, nC) + 1;        
        bigIm((1 + (r-1)*h):(r*h), (1+ (c-1)*w):(c*w)) = reshape(data(:,i), h, w);
    end; 
end;