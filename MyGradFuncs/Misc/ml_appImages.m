function bigIm = ml_appImages(imSeq, nImPerRow, mode)
% Given a stack of images of the same size, append images to create a big image.
% Inputs:
%   imSeq: the stack of image. imSeq is 3 dim tensor. If the mode is color
%   then the there is 3*n 2D images, n is total number of images.
%   nImPerRow: the number of images per row
%   mode: whether each image is color or gray scale
% Outputs:
%   bigIm: the giant image obtained.
% By Minh Hoai Nguyen
% Date: 21 Feb 07

if strcmp(mode, 'color')
    bigIm(:,:,1) = m_appLayer(imSeq(:,:,1:3:end), nImPerRow);
    bigIm(:,:,2) = m_appLayer(imSeq(:,:,2:3:end), nImPerRow);
    bigIm(:,:,3) = m_appLayer(imSeq(:,:,3:3:end), nImPerRow);
else
    bigIm = m_appLayer(imSeq, nImPerRow);
end;
    


function bigIm = m_appLayer(imSeq, nImPerRow)
    [h,w, n] = size(imSeq);

    nC = nImPerRow;
    nR = ceil(n/nC);
    bigIm = zeros(nR*h, nC*w);
    for i = 1:n;
        r = ceil(i/nC);
        c = mod(i-1, nC) + 1;        
        bigIm((1 + (r-1)*h):(r*h), (1+ (c-1)*w):(c*w)) = imSeq(:,:,i);
    end;

