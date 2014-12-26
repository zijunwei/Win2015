function [accM, winIm, XI, YI] = m_kAlign_rigid(D, im, kOpts, XI, YI, ...
    mode, M0, shldDisp)
% [accM, winIm, XI, YI] = m_kAlign_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp)
% This function does kernel alignment for rigid transformation. There are
% two type of transformation supported: affine and translation.
% Inputs:
%   D: The data given in column format.
%   im: the test image, that we need to to find alignment parameters.
%   kOpts: the structure that define kernel options.
%       kOpts.kernelType: type of kernel, either 'exp' or 'poly'
%       kOpts.deg: if the kernel type is 'poly', what degree.
%       kOpts.gamma: if kernel is 'exp': k(x,y) = exp(-gamma*||x-y||^2)
%           if kernel is 'poly', k(x,y) = (<x,y> + gamma)^deg
%       kOpts.energy: the energy that KPCA should preserve.
%   XI, YI: The X and Y indexes of pixels that we need to align (initial
%       positions). XI, YI are two column vectors.
%   mode: type of transformation used, two possible values: 'affine' or
%       'translation'. mode is a string.
%   M0: the initial estimate of transformation parameters. See output accM 
%       for more details about format. If no intial estimate, M0 should be
%       set of [].
%   shldDisp: should display details of each iteration or not. The default
%       value is false.
% Outputs:
%   accM: accumuated transformation. accM is  the transformation params
%       that bring the XI, YI to correct positions. If mode is 'affine',
%       accM and M0 are 3*3 matrix. If mode is 'translation', accM and M0
%       are 2*1 translation vectors.
%   winIm: the value of pixels at the aligned position (final iteration).
%   XI, YI: final positions of initial XI, YI after transformation.
% By Minh Hoai Nguyen
% Date: 26 May 07


if strcmp(kOpts.kernelType, 'exp')
    K = exp(-(kOpts.gamma)*m_sqrDist(D,D));        
elseif strcmp(kOpts.kernelType, 'poly')
    K = (D'*D + kOpts.gamma).^(kOpts.deg);
end
[Alphas, betas, const] = ml_kpcaProjCoeffs(K, kOpts.energy, 1);
d2 = sum(D.*D,1)';    

%Meshgrid of qqinterp2
[imH, imW] = size(im);
XGrid = [1 1 imH];
YGrid = [1 1 imW];
[imDx, imDy] = gradient(im); %image gradient.


if shldDisp
    minXI = min(XI); maxXI = max(XI);
    minYI = min(YI); maxYI = max(YI);
    winH = round(maxYI - minYI + 1);
    winW = round(maxXI - minXI + 1);
    imHolder = zeros(winH, winW);
    linXYI = sub2ind([winH, winW], YI - minYI+1, XI - minXI+1);
end;

maxIters = 150;    
if strcmp(mode, 'translation')
    if isempty(M0)
        M0 = zeros(2,1);
    end;
    XI = XI + M0(1); YI = YI + M0(2);
    accM = M0;
    for i=1:maxIters            
        [winIm, winDx, winDy]  = qqinterp2(XGrid,YGrid, XI,YI, im, imDx, imDy);
        if shldDisp
            dispIterDetail(D, Alphas, betas, const, kOpts, winIm, ...
                imHolder, linXYI, i);
        end;

        % Jacobian for translation case.
        Ja = [winDx(:), winDy(:)];
        a = m_cmpParamIncr(D, d2, Alphas, betas, kOpts, winIm(:), Ja);            

        if ~chkIncrParam(a), break; end;
        XI = XI + a(1);
        YI = YI + a(2);            
        accM = accM + a;
    end;
elseif strcmp(mode, 'affine')
    if isempty(M0)
        M0 = eye(3);
    end;
    adjXYI =  [XI, YI, ones(length(XI),1)]*M0';
    XI = adjXYI(:,1); YI = adjXYI(:,2);
    accM = M0;
    for i=1:maxIters
        [winIm, winDx, winDy]  = qqinterp2(XGrid,YGrid, XI,YI, im, imDx, imDy);
        if shldDisp
            dispIterDetail(D, Alphas, betas, const, kOpts, winIm, ...
                imHolder, linXYI, i);
        end;

        % Affine motion [x_new, y_new,1] = [x,y,1]'+ M*[x,y,1]';
        % Here M is 3*3 matrix [a b c; d e f; 0 0 1];
        sclXI = XI/imW;
        sclYI = YI/imH;
        Ja = [winDx.*sclXI, winDx.*sclYI, winDx, winDy.*sclXI, winDy.*sclYI, winDy];
        a = m_cmpParamIncr(D, d2, Alphas, betas, kOpts, winIm(:), Ja);
        if ~chkIncrParam(a), break; end;
        M = [1 + a(1)/imW, a(2)/imH, a(3); a(4)/imW, 1+ a(5)/imH, a(6); 0 0 1];
        newXYI =  [XI, YI, ones(length(XI),1)]*M';
        XI = newXYI(:,1);
        YI = newXYI(:,2); 
        accM = M*accM;
    end;
end;
fprintf('Number of iters: %d\n', i);
    

%Check if the increment parameter is good.
function isGood = chkIncrParam(a)        
    if sumsqr(isnan(a))
        fprintf(2, 'chkIncrParam: some entries of increment parameters are NaN');
        isGood = false;
    elseif max(abs(a(:))) < 1e-4
        isGood = false;
    else
        isGood = true;
    end;
    
%Compute error and display image and alignment results.    
function err = dispIterDetail(D, Alphas, betas, const, kOpts, winIm, ...
        imHolder, linXYI, iterIdx)
    imHolder(linXYI) = winIm;
    subplot(15,10,iterIdx); 
    imshow(uint8(imHolder));
%     imshow(imHolder);
    if (strcmp(kOpts.kernelType, 'exp'))
        dK = exp(-kOpts.gamma*m_sqrDist(D, winIm)); 
        err = 1 - dK'*Alphas*dK - betas'*dK + const;
    elseif (strcmp(kOpts.kernelType, 'poly'))
        dK = (D'*winIm + kOpts.gamma).^(kOpts.deg);
        err = (winIm'*winIm + kOpts.gamma).^(kOpts.deg)  - ...
            dK'*Alphas*dK - betas'*dK + const;
    end;
    fprintf('Error at iter %d: %g\n', iterIdx, err);
    
