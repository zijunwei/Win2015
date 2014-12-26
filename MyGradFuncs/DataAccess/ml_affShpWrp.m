function WrpShp = ml_affShpWrp(Shps, a)
% warp the shape by an affine transformation
% Inputs:
%   Shp: 2k*n vector for coordinates of k landmarks for n shapes. 
%       The first k components of each column
%       are X-coordinates. The last k components are Y-coordinates.
%   a: affine parmameters.
% Output:
%   wrpShp: warped shapes.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 18 Oct 2008

d = size(Shps,1);
k = d/2;
X = Shps(1:k,:);
Y = Shps(k+1:end,:);
WrpShp = zeros(size(Shps));
WrpShp(1:k,:)     = a(1)*X + a(2)*Y + a(3);
WrpShp(k+1:end,:) = a(4)*X + a(5)*Y + a(6);
