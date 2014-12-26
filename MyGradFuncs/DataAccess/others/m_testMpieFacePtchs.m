function m_testMpieFacePtchs()
    load('D:\Study\DataSets\multipie\imlmlist_surprise.mat');
%     load 'X:\Data\multipie\imlmlist_winSCS_surprise.mat';
%     load 'X:\Data\multipie\imlmlist_winSCS_scream.mat';
%     load 'X:\Data\multipie\imlmlist_winSCS_squint.mat';
%     load 'X:\Data\multipie\imlmlist_winSCS_smile_01_02.mat';
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam041.mat';
%     load 'Y:\Data\multipie\imlmlist_winAndrew_light05_cam051.mat';

    scl = 0.25;
    [mShape, AlgnParams] = ml_mpieShpAffAlgn(lmlist, scl);
    imSz = round(scl*[480, 640]);

%     % This line to test ml_mpieFacePtchs
%     ptchXYI = ml_mpieFacePtchs(imSz, mShape, 10);
    
    % This line to test ml_mpieFacePtchs2
    ptchXYI = ml_mpieFacePtchs2(imSz, mShape, scl);

    figure;
    scatter(mShape(:,1), mShape(:,2), 'ob');
    axis image; axis ij; hold on;
    
    for i=1:68
        pts = ptchXYI{i};
        scatter(pts(:,1), pts(:,2), '.r');
    end;