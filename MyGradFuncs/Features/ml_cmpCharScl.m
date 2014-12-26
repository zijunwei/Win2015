function CharScl = ml_cmpCharScl(im, minScl, maxScl)
% computing characteristic scale for every pixels in an image.
% This use extremum of absolute DoG (approx for Laplacian).
% Inputs:
%   im: an image grayscale or RGB
%   minScl: minimum scale considered.
%   maxScl: maximum scale considered.
% Outputs:
%   CharScl: a imH*imW image for the characteristic scales.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 5 Nov 2008

if ~exist('minScl', 'var') || isempty(minScl)
    minScl = 1;
end;

if ~exist('maxScl', 'var') || isempty(maxScl)
    minScl = 10;
end;


if size(im, 3) > 1
    im = rgb2gray(im);
end;
im = double(im);

sigma_0 = minScl;
xi = 1.2;
n = 1 + floor(log(maxScl/minScl)/log(xi));

DoGs = cmpAbsDoGs(im, sigma_0, xi, n);
[dc, IX] = max(DoGs, [], 3);
CharScl = minScl*xi.^(IX-1);



% Compute absolute difference of Gaussians.
function DoGs = cmpAbsDoGs(Im, sigma_0, xi, nLevel)
    [imH, imW] = size(Im);

    % construct a Gaussian pyramid
    Gs = zeros(imH, imW, nLevel+1);
    for i=1:(nLevel+1)
        Gs(:,:,i) = ml_gaussConv(Im, sigma_0*xi^(i-1));    
    end;

    % Get a pyramid for difference of Gaussians.
    DoGs = zeros(imH, imW, nLevel);
    for i=1:nLevel
        DoGs(:,:,i) = abs(Gs(:,:,i+1) - Gs(:,:,i));
    end;


