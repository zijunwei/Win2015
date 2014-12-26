function m_testMpieShpEuclidAlgn()
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam051.mat';
    load 'X:\Data\multipie\imlmlist_winSCS_scream.mat';
    scl = 0.5;
%     lmPtIdxs = [18:27, 37:48];
    lmPtIdxs = [];
    [mShape, AlgnParams] = ml_mpieShpEuclidAlgn(lmlist, scl, lmPtIdxs);
    
    figure; subplot(2,1,1); scatter(mShape(:,1), mShape(:,2));
    axis ij image;
    
    testImIdx = 50;
    im = imresize(imread(imglist{testImIdx}), scl);
    load(lmlist{testImIdx}, 'pts');
    pts = scl*pts;
    
    subplot(2,1,2); imshow(im); hold on;
    scatter(pts(:,1), pts(:,2), '.r');
    
    v = AlgnParams(:, testImIdx);
    M = [v(1), -v(2), v(3); ...
         v(2),  v(1), v(4); ...
         0 0 1];
     
    algnPts = [mShape, ones(size(mShape,1),1)]*M';
    scatter(algnPts(:,1), algnPts(:,2), '+b');
     
 