function [im4print46, im4print57] = ml_photo4passport(im)
% given a 6x4 image, create a photo for passport print

im = imrotate(im, 90);

imH = size(im,1);
imW = size(im,2);

imH_vi = 1575;

imSz_vi = [imH_vi, round(imW/imH*imH_vi)];
im_vi = imresize(im, imSz_vi);

padSz = 100;
im_vi = padarray(im_vi, [padSz, padSz], 255, 'both');

C = repmat(im_vi, [2,2,1]); 

desireH = 4000; % 4x6 in
desireW = 6000; 
padW = (desireW - size(C,2))/2;
padH = (desireH - size(C,1))/2;

im4print46 = padarray(C, [padH, padW, 0], 255, 'both');

desireH = 5000; % 5x7 in
desireW = 7000; 
padW = (desireW - size(C,2))/2;
padH = (desireH - size(C,1))/2;
im4print57 = padarray(C, [padH, padW, 0], 255, 'both');
