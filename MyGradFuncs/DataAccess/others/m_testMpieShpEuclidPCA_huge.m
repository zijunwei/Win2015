function m_testMpieShpEuclidPCA2()
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam051.mat';
%     load 'X:\Data\multipie\imlmlist_winSCS_surprise.mat';
    load('D:\Study\Projects\AU Recogn\data\S010_AAM_lm.mat', 'lmPts');
      
    scl = 0.5;
    testImIdx = 150;

    lmPtIdxs = [37, 40, 43, 46, 28:36];
%     lmPtIdxs = [];
    
    ml_mpieShpEuclidPCA_huge(lmPts(:,1:1000), scl, .99, 1, lmPtIdxs);
    
    load('./tmp/mShape.mat');
    load('./tmp/AlgnParams.mat');
    load('./tmp/NRAlgnParams.mat');
    load('./tmp/AlgnShps.mat');
    load('./tmp/ShpBasis.mat');
    
    mShape = reshape(mShape, 68,2);
    figure; subplot(2,1,1); scatter(mShape(:,1), mShape(:,2), '+b');
    axis ij image; hold on;
    algnShp = AlgnShps(:,testImIdx);
    scatter(algnShp(1:68), algnShp(69:end), '.r');
    
    m = 4; % number of Non-rigid coefficients and basis to use.
    
    algnShp = AlgnShps(:,testImIdx) - ShpBasis(:, 1:m)*NRAlgnParams(1:m, testImIdx);
    scatter(algnShp(1:68), algnShp(69:end), 'xc');
    
    
    
    pts = reshape(scl*lmPts(:,testImIdx),68,2);
    
    subplot(2,1,2); 
    scatter(pts(:,1), pts(:,2), '.r'); hold on; axis ij image;
    
    v = AlgnParams(:, testImIdx);
    M = [v(1), -v(2), v(3); ...
         v(2),  v(1), v(4); ...
         0 0 1];
        
     
    algnPts = [mShape, ones(size(mShape,1),1)]*M';
    scatter(algnPts(:,1), algnPts(:,2), '+b');
    
    adjMShape = mShape(:) + ShpBasis(:, 1:m)*NRAlgnParams(1:m, testImIdx);
    algnPts = [adjMShape(1:68), adjMShape(69:end), ones(68,1)]*M';   
    
    scatter(algnPts(:,1), algnPts(:,2), 'xc');    
     
 