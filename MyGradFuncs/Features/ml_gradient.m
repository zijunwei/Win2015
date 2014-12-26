function [Ix, Iy] = ml_gradient(Im, sigma)
% function function [Ix, Iy] = ml_gradient(Im, sigma)
% Compute the gradient images of Im
% Inputs:
%   Im: the image
%   sigma: the sigma for the Gaussian smoothing
% Outputs:
%   Ix, Iy: gradient images in x and y direction
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 15 Oct 2008

Im = double(Im);

% 1D Gaussian filter 
G_dif = fspecial('gaussian', [2*ceil(3*sigma) + 1, 1], sigma);

% 1D derivative of Gaussian filter.
dG_dif = ml_gaussDerivative(sigma);

Ix = conv2(Im', dG_dif, 'same')';
Ix = conv2(Ix, G_dif, 'same');
Iy = conv2(Im, dG_dif, 'same');
Iy = conv2(Iy', G_dif, 'same')';
