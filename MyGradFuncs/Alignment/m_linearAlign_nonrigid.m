function A = m_linearAlign_nonrigid(D, im, kOpts, ...
        ptchXYIs, mShp, shpBasis, A0, shldDisp)
% A = m_linearAlign_nonrigid(D, im, kOpts, ptchXYIs, mShp, shpBasis, A0, shldDisp)
% This function computes the non-rigid transformation parameters for linear
% alignment system.
% Inputs:
%   D: The data given in column format.
%   im: the test image, that we need to to find alignment parameters.
%   kOpts: the structure that define kernel options.
%       kOpts.energy: energy level that KPCA should preserve.
%   ptchXYIs: This is a cell of 68 elements. ptchXYI{i} is a
%       n(i)*2 matrix which is the XI, YI of pixels inside square patch
%       around the landmark i_th and inside the face. ptchXYIs is computed
%       by function: ml_mpieFacePtchs. Look at that function for more
%       details.
%   mShp: mean shape of landmark points. This is a column vector.
%   shpBasis: the basis of shape variations. Each column is a basis vector.
%       Look at function ml_mpieShpPCA for more details.
%   A0: intial estimate of transformation params. This could be se to [].
%   shldDisp: should display details of each iteration. If this is set to
%       be 1. The function will compute kernel PCA reconstruction error at
%       each iteration and display it. It also display the aligned shape
%       using transformation params computed at each iteration. The default
%       value is 0 (false)
% Output:
%   A: Transformation parameters necessary for alignment. The first 6 
%       entries of A are for affine transformation. A(7:end) are for 
%       non-rigid transformation.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 12 June 07

mD = mean(D, 2);
cenD = D - repmat(mD, 1, size(D,2));

%%% Caching for faster experiments.
% persistent PcaBasis
% if isempty(PcaBasis)
%     PcaBasis = ml_pca(cenD, kOpts.energy, 1);    
% end;

%%% Non-caching version.
PcaBasis = ml_pca(cenD, kOpts.energy, 1);    
pinvPcaBasis = pinv(PcaBasis);


k = size(shpBasis,2); % number of basis vectors for shape.

%Meshgrid of qqinterp2
[imH, imW] = size(im);
XGrid = [1 1 imH];
YGrid = [1 1 imW];
[imDx, imDy] = gradient(im); %image gradient.    

% The first 6 elems are affine, the rest is for non-rigid
if ~exist('A0', 'var') || isempty(A0)
    A = [1 0 0 0 1 0 zeros(1, k)]';
else
    A = A0;
end;

%Scale the paramters to consitent with scaled XI, YI.
A([1,4]) = A([1,4])*imW;
A([2,5]) = A([2,5])*imH;    

[XI, YI, lShpBasisX, lShpBasisY] = ...
    ml_cmpLongPtchXYIs(ptchXYIs, shpBasis);

% work with scaled version to avoid numerical problems.
sclXI = XI/imW;
sclYI = YI/imH;
sclLShpBasisX = lShpBasisX/imW;
sclLShpBasisY = lShpBasisY/imH;

if ~exist('shldDisp', 'var')
    shldDisp = 0;
end;    

maxIters = 300;        
for i=1:maxIters
    M = [A(1), A(2), A(3); A(4), A(5), A(6); 0 0 1];   

    %XI and YI after the non-rigid transformation.
    sclXI2 = sclXI + sclLShpBasisX*A(7:end);
    sclYI2 = sclYI + sclLShpBasisY*A(7:end);        

    %XI and YI after non-rigid and affine transformation.
    curXYI = [sclXI2, sclYI2, ones(length(sclXI2),1)]*M';               

    [winIm, winDx, winDy]  = qqinterp2(XGrid,YGrid, ...
        curXYI(:,1), curXYI(:,2), im, imDx, imDy);


    %Jacobian of affine motion.
    Ja = [winDx.*sclXI2, winDx.*sclYI2, winDx, ...
        winDy.*sclXI2, winDy.*sclYI2, winDy];
    %Jacobian for non-rigid motion:
    Jalpha =(A(1)*sclLShpBasisX + A(2)*sclLShpBasisY).*repmat(winDx,1,k) + ...
        (A(4)*sclLShpBasisX + A(5)*sclLShpBasisY).*repmat(winDy,1,k);

    J = [Ja, Jalpha]; %combined Jacobian
    
    cenWinIm = winIm - mD; % subtract mean        
    c = pinvPcaBasis*cenWinIm; %PCA coefficient        
    paramIncr = pinv(J)*(PcaBasis*c - cenWinIm);
    
    if shldDisp 
        mShp2 = mShp + shpBasis*A(7:end);
        sclMShp = [mShp2(1:68)/imW, mShp2(69:end)/imH];
        warpShp = [sclMShp, ones(68,1)]*M';
        dispIterDetail(PcaBasis, mD, winIm, c, im, warpShp, i);
    end;

    
    if ~chkIncrParam(paramIncr, imH, imW), break; end;
    A = A + paramIncr;
end;
fprintf('Number of iters: %d\n', i);
A([1,4]) = A([1,4])/imW;
A([2,5]) = A([2,5])/imH;
 

% Check if the param increment a is good.
function isGood = chkIncrParam(a, imH, imW)    
    a([1,4]) = a([1,4])/imW;
    a([2,5]) = a([2,5])/imH;
    if sumsqr(isnan(a))
        error('some entries of increment parameters are NaN');
    elseif max(abs(a(:))) < 1e-4
        isGood = false;
    else
        isGood = true;
    end;
    
%Compute error and display image and alignment results.    
function err = dispIterDetail(PcaBasis, mD, winIm, c, im, warpShp, iterIdx)
%     subplot(15,14,iterIdx); imshow(uint8(im));
    hold on; scatter(warpShp(:,1), warpShp(:,2), '.r');
    
    diff = winIm -mD - PcaBasis*c;
    err = diff'*diff;
    fprintf('Error at iter %d: %g\n', iterIdx, err);
    
