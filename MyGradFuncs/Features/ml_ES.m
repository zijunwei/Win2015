function [Gx, Gy] = ml_ES(Im, sigma, g0, modulo)
% function [Gx, Gy] = ml_ES(Im, sigma, g0)
% Compute Edge Structure
% Based on the paper:
% Cootes Taylor, On Representing Edge Structure for Model Matching, CVPR01
% Inputs:
%   Im: image
%   sigma: sigma for compute image gradient
%   g0: a number for mean or median of edge strength sqrt(Ix^2 + Iy^2)
%   modulo:
%       180: oriented edge without polarity
%       360: oriented edge with polarity
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 15 Oct 2008

[Ix, Iy] = ml_gradient(Im, sigma);
Ix2 = Ix.^2;
Iy2 = Iy.^2;
G  = sqrt(Ix2 + Iy2);

if modulo == 360
    Gx = Ix./(G + g0);
    Gy = Iy./(G + g0);
elseif modulo == 180
    GG0 = (G.*(G+g0));
    Gx = (Ix2 - Iy2)./GG0;
    Gy = 2*Ix.*Iy./GG0;
end;