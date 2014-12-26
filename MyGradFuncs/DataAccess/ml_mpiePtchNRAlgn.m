function AlgnPtchApps = ml_mpiePtchNRAlgn(imFileList, AlgnParams, NRAlgnParams, ShpBasis, ...
    ptchXYIs, mode, scl)
% function AlgnPtchApps = ml_mpiePtchNRAlgn(imFileList, AlgnParams, NRAlgnParams, ShpBasis,
%       ptchXYIs, mode, scl)
%   Compute the patch appearance after aligning using non-rigid and affine transformation.
%
% Inputs:
%   imFileList: a list of names of image files.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
%       will align the mean shape to the shape of the i_th image.
%       [x';y';1] = M*[x; y; 1];
%   NRAlgnParams: align params for non-rigid transformation. Each column 
%       u = NRAlgnParams(:,i) is a vector that defines nonrigid
%       transformation parameters. 
%   ShpBasis: The basis of shape variation.
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. Note the number of 
%       pixels are different for different landmarks.
%   mode: either 'color' or 'gray', default: 'color'
%   scl: the scale of images that we should operate on, default: 1
% Outputs:
%   AlgnPtchApps: rigid + non-rigid aligned patch appearance.
% See also: ml_mpiePtchAffAlgn.m. That function produces similar results to this function. The differences are:
%   + ml_mpiePtchAffAlgn.m function uses AlgnShps to determine the warped landmark points.
%   + The landmark points used by this function are obtained by: (i) project AlgnShps to non-rigid 
%       shape basis, (ii) reconstruct the AlgnShps by the shape basis. There is something lost by during
%       projection and reconstruction.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 9 Oct 07

if ~exist('mode', 'var')
    mode = 'color';
end;
if ~exist('scl','var')
    scl = 1;
end;

fprintf('Process image 0000');
for i=1:size(imFileList,1)
    fprintf('\b\b\b\b%4d', i);
    
    im = imread(imFileList{i});
    im = imresize(im, scl);
    shpParam = [AlgnParams(:,i); NRAlgnParams(:,i)];
    if strcmp(mode, 'color')        
        im = double(im);
        winImR = ml_cmpMpieAppNJacobian(im(:,:,1), shpParam, ptchXYIs, ShpBasis, 'App');
        winImG = ml_cmpMpieAppNJacobian(im(:,:,2), shpParam, ptchXYIs, ShpBasis, 'App');
        winImB = ml_cmpMpieAppNJacobian(im(:,:,3), shpParam, ptchXYIs, ShpBasis, 'App');        
        AlgnPtchApps(:,i) = [winImR; winImG; winImB];
    elseif strcmp(mode, 'gray')
        im = double(rgb2gray(im));
        AlgnPtchApps(:,i) = ml_cmpMpieAppNJacobian(im, shpParam, ptchXYIs, ShpBasis, 'App');
    end;
end;
fprintf('\n');
