function [im4print46, im4print57] = ml_photo4visa(im)
% Given a squared image, create an image to print for visa



imH = size(im,1);
imW = size(im,2);

imH_us = 2000;
%imW_us = 2000;
imH_eu = 1772;
%imW_europe = 1378;

imSz_us = [imH_us, round(imW/imH*imH_us)];
imSz_eu = [imH_eu, round(imW/imH*imH_eu)];


im_us = imresize(im, imSz_us);
im_eu = imresize(im, imSz_eu);

padSz = 5;
im_us = padarray(im_us, [padSz, padSz], 255, 'both');
im_eu = padarray(im_eu, [padSz, padSz], 255, 'both');

A = repmat(im_us, [1,2,1]); 
B = repmat(im_eu, [1,3,1]); 
A(:,size(A,2)+1:size(B,2),:) = 255;

C = cat(1, A, B);

desireH = 4000; % 4x6 in
desireW = 6000; 
padW = (desireW - size(C,2))/2;
padH = (desireH - size(C,1))/2;

im4print46 = padarray(C, [padH, padW, 0], 255, 'both');

desireH = 5000; % 4x6 in
desireW = 7000; 
padW = (desireW - size(C,2))/2;
padH = (desireH - size(C,1))/2;
im4print57 = padarray(C, [padH, padW, 0], 255, 'both');




