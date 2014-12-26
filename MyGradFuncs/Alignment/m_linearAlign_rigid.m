function [accM, winIm, XI, YI] = m_linearAlign_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp)
% [accM, winIm, XI, YI] = m_linearAlign_rigid(D, im, kOpts, XI, YI, mode, M0, shldDisp)
% This function does kernel alignment for rigid transformation. There are
% two type of transformation supported: affine and translation.
% Inputs:
%   D: The data given in column format.
%   im: the test image, that we need to to find alignment parameters.
%   kOpts: the structure that define kernel options.
%       kOpts.energy: the energy that PCA should preserve.
%   XI, YI: The X and Y indexes of pixels that we need to align (initial
%       positions). XI, YI are two column vectors.
%   mode: type of transformation used, two possible values: 'affine' or
%       'translation'. mode is a string.
%   M0: the initial estimate of transformation parameters. See output accM 
%       for more details about format. If no intial estimate, M0 should be
%       set of [].
%   shldDisp: should display details of each iteration or not. 
% Outputs:
%   accM: accumuated transformation. accM is  the transformation params
%       that bring the XI, YI to correct positions. If mode is 'affine',
%       accM and M0 are 3*3 matrix. If mode is 'translation', accM and M0
%       are 2*1 translation vectors.
%   winIm: the value of pixels at the aligned position (final iteration).
%   XI, YI: final positions of initial XI, YI after transformation.
% By Minh Hoai Nguyen
% Date: 12 June 07


mD = mean(D, 2);
cenD = D - repmat(mD, 1, size(D,2));
PcaBasis = ml_pca(cenD, kOpts.energy, 1);
pinvPcaBasis = pinv(PcaBasis);


%Meshgrid for qqinterp2
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

        
        cenWinIm = winIm - mD; % subtract mean        
        c = pinvPcaBasis*cenWinIm; %PCA coefficient        
        Ja = [winDx(:), winDy(:)]; % Jacobian for translation case.
        if sumsqr(isnan(Ja))
            fprintf(2, 'm_linearAlign_rigid: some entries of Ja are NAN');
            a = 0;
        else
            a= inv(Ja'*Ja)*(Ja'*(PcaBasis*c - cenWinIm));
            % a = pinv(Ja)*(PcaBasis*c - cenWinIm); The above might be
            % faster.
        end;

        if ~chkIncrParam(a), break; end;
        XI = XI + a(1);
        YI = YI + a(2);            
        accM = accM + a;
        if shldDisp
            dispIterDetail(PcaBasis, mD, winIm, c, imHolder, linXYI, i);
        end;    
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
        % Affine motion [x_new, y_new,1] = [x,y,1]'+ M*[x,y,1]';
        % Here M is 3*3 matrix [a b c; d e f; 0 0 1];
        sclXI = XI/imW;
        sclYI = YI/imH;
        
        cenWinIm = winIm - mD; % subtract mean        
        c = pinvPcaBasis*cenWinIm; %PCA coefficient   
        Ja = [winDx.*sclXI, winDx.*sclYI, winDx, winDy.*sclXI, winDy.*sclYI, winDy];       
        if sumsqr(isnan(Ja))
            fprintf(2, 'm_linearAlign_rigid: some entries of Ja are NAN');
            a = 0;
        else
            a= inv(Ja'*Ja)*(Ja'*(PcaBasis*c - cenWinIm));
            % a = pinv(Ja)*(PcaBasis*c - cenWinIm); The above might be faster.
        end;
        
        if ~chkIncrParam(a), break; end;
        M = [1 + a(1)/imW, a(2)/imH, a(3); a(4)/imW, 1+ a(5)/imH, a(6); 0 0 1];
        newXYI = [XI, YI, ones(length(XI),1)]*M';
        XI = newXYI(:,1);
        YI = newXYI(:,2); 
        accM = M*accM;
        if shldDisp
            dispIterDetail(PcaBasis, mD, winIm, c, imHolder, linXYI, i);
        end;    
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
function err = dispIterDetail(PcaBasis, mD, winIm, c, imHolder, linXYI, iterIdx)
    imHolder(linXYI) = winIm;
    subplot(15,10,iterIdx); 
    imshow(uint8(imHolder));
%     imshow(imHolder);
    diff = winIm -mD - PcaBasis*c;
    err = diff'*diff;
    fprintf('Error at iter %d: %g\n', iterIdx, err);

    
