function m_testProcustes()
% Test

load('D:\Study\DataSets\multipie\imlmlist_surprise.mat');

LmPts = zeros(136, length(lmlist));
for i=1:length(lmlist)
    load(lmlist{i}, 'pts');
    LmPts(:,i) = pts(:);
end;


[stdShp, AlgnParams, AlgnLmPts] = ml_procrustes(LmPts, [37 40 43 46 49 55]);

figure; scatter(stdShp(1:68), stdShp(69:end), '*r'); axis ij image; hold on;
i = 1; scatter(AlgnLmPts(1:68, i), AlgnLmPts(69:end, i), '.m');
i = 23; scatter(AlgnLmPts(1:68, i), AlgnLmPts(69:end, i), '.k');
i = 13; scatter(AlgnLmPts(1:68, i), AlgnLmPts(69:end, i), '.b');


% figure; scatter(stdShp(1:68), stdShp(69:end), '*r'); axis ij image; hold on;
% for i=1:68
%     text(stdShp(i), stdShp(i+68), sprintf(' %d',i));
% end;
keyboard;