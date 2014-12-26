function m_testMpieShpAffPCA()
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam051.mat';
    load 'X:\Data\multipie\imlmlist_winSCS_surprise.mat';
    scl = 0.5;
    testImIdx = 50;

%     lmPtIdxs = [18:27, 37:48];
    lmPtIdxs = [];
    
    [mShape, AlgnParams, NRAlgnParams, AlgnShps, ShpBasis] = ...
        ml_mpieShpAffPCA(lmlist, scl, 15, 0, lmPtIdxs);
    
    mShape = reshape(mShape, 68,2);
    figure; subplot(2,1,1); scatter(mShape(:,1), mShape(:,2), '+b');
    axis ij image; hold on;
    algnShp = AlgnShps(:,testImIdx);
    scatter(algnShp(1:68), algnShp(69:end), '.r');
    
    m = 12; % number of Non-rigid coefficients and basis to use.
    
    algnShp = AlgnShps(:,testImIdx) - ShpBasis(:, 1:m)*NRAlgnParams(1:m, testImIdx);
    scatter(algnShp(1:68), algnShp(69:end), 'xc');
    
    
    
    im = imresize(imread(imglist{testImIdx}), scl);
    load(lmlist{testImIdx}, 'pts');
    pts = scl*pts;
    
    subplot(2,1,2); imshow(im); hold on;
    scatter(pts(:,1), pts(:,2), '.r');
    
    v = AlgnParams(:, testImIdx);
    M = [v(1:3)'; v(4:6)'; 0 0 1];
     
    algnPts = [mShape, ones(size(mShape,1),1)]*M';
    scatter(algnPts(:,1), algnPts(:,2), '+b');
    
    adjMShape = mShape(:) + ShpBasis(:, 1:m)*NRAlgnParams(1:m, testImIdx);
    algnPts = [adjMShape(1:68), adjMShape(69:end), ones(68,1)]*M';   
    
    scatter(algnPts(:,1), algnPts(:,2), 'xc');    
     
 