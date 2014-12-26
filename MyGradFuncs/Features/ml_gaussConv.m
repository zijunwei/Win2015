function convIm = ml_gaussConv(Im, sigma)
% function convIm = m_gaussConv(Im, sigma)
% Convolving an image with a spherical gaussian
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 25 Sep 2008

% 1D Gaussian filter
G = fspecial('gaussian', [2*ceil(3*sigma) + 1, 1], sigma);
convIm = conv2(Im, G, 'same');
convIm = conv2(convIm', G, 'same')'; 
%convIm = conv2(convIm, G', 'same'); % this is slower than the line above
% This is because Matlab data is column major!

% % ALTERNATIVE METHODS.
% % ALL the below methods give the same result. However they are all slower
% % The methods get slower as you proceed from the top to the bottom.
% fprintf('using imfilter with sepaparable filters\n');
% tic;
% convIm0 = imfilter(Im, G);
% convIm0 = imfilter(convIm0', G)'; 
% toc;
% 
% 
% G2 = fspecial('gaussian', 2*ceil(3*sigma) + 1, sigma);
% 
% fprintf('using imfilter with 2D Gaussian filter and correlation\n');
% tic;
% convIm2 = imfilter(Im, G2);
% toc;
% 
% fprintf('using imfilter with 2D Gaussian filter and convolution\n');
% tic;
% convIm3 = imfilter(Im, G2, 'conv');
% toc;
% 
% fprintf('using conv2 with 1D Gaussian filter twice\n');
% tic;
% convIm1 = conv2(G, G', Im, 'same');
% toc;
% 
% fprintf('using conv2 with 2D Gaussian filters\n');
% tic;
% convIm4 = conv2(Im, G2, 'same');
% toc;

