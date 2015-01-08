function A = ml_rand(h, w, minVal, maxVal, shldReuseSeed)
% function A = ml_rand(h, w, minVal, maxVal, shldReuseSeed)
% Generate uniformly random integers from minVal to maxVal
% Inputs:
%   h, w: height and width of the output matrix.
%   minVal, maxVal: 2 integers for the minimum and maximum values.
%   shldReuseSeed: should reuse seed of random generator or not.
%       if you call this function twice without reusing seed option
%       it will general similar random numbers in two calls.
% Outputs:
%   A: h*w matrix for uniformly random integers from minVal to maxVal
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 4 Sep 2008

if ~exist('shldReuseSeed', 'var') || ~shldReuseSeed
    rand('twister', sum(100*clock));
end;

A = rand(h, w);
A = ceil(A*(maxVal - minVal+1)) + minVal - 1;
