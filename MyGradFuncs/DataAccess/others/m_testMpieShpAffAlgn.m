function m_testMpieShpAffAlgn()
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam051.mat';
    load 'X:\Data\multipie\imlmlist_winSCS_scream.mat';
    scl = 0.5;
    lmPtIdxs = [18:27, 37:48];
%     lmPtIdxs = [];
    [mShape, AlgnParams] = ml_mpieShpAffAlgn(lmlist, scl, lmPtIdxs);
    
    figure; subplot(2,1,1); scatter(mShape(:,1), mShape(:,2));
    axis ij image;
    
    testImIdx = 50;
    im = imresize(imread(imglist{testImIdx}), scl);
    load(lmlist{testImIdx}, 'pts');
    pts = scl*pts;
    
    subplot(2,1,2); imshow(im); hold on;
    scatter(pts(:,1), pts(:,2), '.r');
    
    v = AlgnParams(:, testImIdx);
    M = [v(1:3)'; v(4:6)'; 0 0 1];
     
    algnPts = [mShape, ones(size(mShape,1),1)]*M';
    scatter(algnPts(:,1), algnPts(:,2), '+b');
     
 