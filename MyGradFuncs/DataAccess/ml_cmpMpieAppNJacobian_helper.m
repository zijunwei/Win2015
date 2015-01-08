function [I, J] = ml_cmpMpieAppNJacobian_helper(im, imDx, imDy, shpParam, ptchXYIs, ShpBasis, mode)
% function [I, J] = ml_cmpMpieAppNJacobian_helper(im, imDx, imDy, shpParam, ptchXYIs, ShpBasis, mode)
% Compute Appearance and Jacobian of w.r.t to shape parameters.
% Inputs:
%   im: the image
%   shpParam: the shape parameters, this is a column vector of size (6+k)*1.
%       The first six components are for affine motion.
%       If we denote A = shpParam, the affine transformation matrix is:
%       M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];
%       The rest of the shpParam is non-rigid shape params.
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. ptchXYIs is computed
%       by function: ml_mpieFacePtchs. Look at that function for more
%       details.
%   ShpBasis: the basis of shape variations. Each column is a basis vector.
%       Look at function ml_mpieShpPCA for more details.
%   mode: valid options are: 'Jacobian', 'App', 'App_Jacobian'. This to set whether
%       this function should compute the Appearance and Jacobian for the corresponding
%       shape params. One should use the correct option because the computational cost 
%       of this function depends on this option.
% Outputs:
%   I: the appearance w.r.t shape params. This is m*1 column vector.
%       If the mode = 'Jacobian' only, I is [].
%   J: the Jacobian of image appearance with respect to shape parameters.
%       This is a m*(6+k) maxtrix. However, if mode = 'App', J is returned empty [].
% See also: ml_cmpMpieAppNJacobian_helper.m
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 9 Oct 2007.
% Last modified: 16 Jun 09 (add code for the case when qqinterp2 fails.

[imH, imW] = size(im);    

persistent XGrid YGrid lShpBasisX lShpBasisY XI YI
global PERVAR_ml_cmpMpieAppNJacobian_helper;
if isempty(XI) || isempty(PERVAR_ml_cmpMpieAppNJacobian_helper)
    XGrid = [1 1 imH]; %Meshgrid of qqinterp2
    YGrid = [1 1 imW];

    [XI, YI, lShpBasisX, lShpBasisY] = ...
        ml_cmpLongPtchXYIs(ptchXYIs, ShpBasis);

    PERVAR_ml_cmpMpieAppNJacobian_helper = 1;
end;

k = size(ShpBasis,2); % number of basis vectors for shape variation.

A = shpParam;

% Affine transformation matrix.
M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];   

%XI and YI after the non-rigid transformation.
XI2 = XI + lShpBasisX*A(7:end);
YI2 = YI + lShpBasisY*A(7:end);        

%XI and YI after non-rigid and affine transformation.
curXYI = [XI2, YI2, ones(length(XI2),1)]*M';               

try
    if strcmp(mode, 'App_Jacobian')
        [I, winDx, winDy]  = qqinterp2(XGrid,YGrid, ...
            curXYI(:,1), curXYI(:,2), im, imDx, imDy);
    elseif strcmp(mode, 'App')
        I = qqinterp2(XGrid, YGrid, curXYI(:,1), curXYI(:,2), im);
        J = [];
    elseif strcmp(mode, 'Jacobian')
        [winDx, winDy]  = qqinterp2(XGrid,YGrid, ...
            curXYI(:,1), curXYI(:,2), imDx, imDy);
        I = [];
    else
        error('ml_cmpMpieAppNJacobian_helper.m: Unknown option for mode. Valid options: App, Jacobian, App_Jacobian');
    end;
catch Me
%     fprintf('ml_cmpMpieAppNJacobian_helper.m: cannot use qqinterp2, the reason is:\n');
%     fprintf(sprintf('  %s\n', Me.message()));
%     fprintf('  --> Switching to Matlab interp2\n');
    if strcmp(mode, 'App_Jacobian')
        I = interp2(1:imW, 1:imH, im, curXYI(:,1), curXYI(:,2));
        winDx = interp2(1:imW, 1:imH, imDx, curXYI(:,1), curXYI(:,2));
        winDy = interp2(1:imW, 1:imH, imDy, curXYI(:,1), curXYI(:,2));        
    elseif strcmp(mode, 'App')        
        I = interp2(1:imW, 1:imH, im, curXYI(:,1), curXYI(:,2));
        J = [];
    elseif strcmp(mode, 'Jacobian')
        winDx = interp2(1:imW, 1:imH, imDx, curXYI(:,1), curXYI(:,2));
        winDy = interp2(1:imW, 1:imH, imDy, curXYI(:,1), curXYI(:,2));        
        I = [];
    else
        error('ml_cmpMpieAppNJacobian_helper.m: Unknown option for mode. Valid options: App, Jacobian, App_Jacobian');
    end;
end
    
if strcmp(mode, 'App_Jacobian') || strcmp(mode, 'Jacobian')
    %Jacobian of affine motion.
    Ja = [winDx.*XI2, winDx.*YI2, winDx, ...
        winDy.*XI2, winDy.*YI2, winDy];

    %Jacobian for non-rigid motion, computation is based on the formulae: df/du = df/dx*dx/du + df/dy*dv/du.
    Jalpha =(A(1)*lShpBasisX + A(2)*lShpBasisY).*repmat(winDx,1,k) + ...
        (A(4)*lShpBasisX + A(5)*lShpBasisY).*repmat(winDy,1,k);

    J = [Ja, Jalpha]; %combined Jacobian
end;

