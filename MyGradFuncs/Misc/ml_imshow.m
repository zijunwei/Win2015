function ml_imshow(I)
% m_imshow: display an image on the current figure.
%   This scale the pixel value range to [0,1] before calling imshow
% Inputs:
%   I: the image handle.
% By: Minh Hoai Nguyen
% Date: 25 Feb 07

imshow(I./max(I(:)));