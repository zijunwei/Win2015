function Data = ml_getCMUFacesData(personIDs, poseIDs, expIDs, glassIDs, imSz)
% poseIDs: [l, r, s, u] = 1:4;
% expIDs: neutral, happy, sad, angry: 1:4;
% glassIDs: [glass, open] = 1:2;
% personIDs: an2i, at33, boland, bpm, ch4f, cheyer, choon, danieln, glickman, karyadi, kawamura, kk49, megak,
%    mitchell, night, phoebe, saavik, steffi, sz24, tammo = 1:20;
% imSz: 1,2, or 4 for 'ori', 'half', 'quarter'.


refPoseIDs = {'left', 'right', 'straight', 'up'};
refExpIDs = {'neutral', 'happy', 'sad', 'angry'};
refGlassIDs = {'sunglasses', 'open'};
refPersonIDs = {'an2i', 'at33', 'boland', 'bpm', 'ch4f', 'cheyer', 'choon', 'danieln', ...
    'glickman', 'karyadi', 'kawamura', 'kk49', 'megak', 'mitchell', 'night', ...
    'phoebe', 'saavik', 'steffi', 'sz24', 'tammo'};

dataDir = 'D:\Study\DataSets\CMUFaces\faces\';
if imSz == 1;
    d = 128*120;
elseif imSz == 2
    d = 64*60;
elseif imSz ==4;
    d = 32*30;
end;
Data = zeros(d, 624);
count = 0;    
for personID=personIDs
    for poseID=poseIDs
        for expID=expIDs
            for glassID=glassIDs
                if imSz == 1
                    fileName = sprintf('%s_%s_%s_%s.pgm', ...
                    refPersonIDs{personID}, refPoseIDs{poseID}, refExpIDs{expID}, refGlassIDs{glassID});
                else
                    fileName = sprintf('%s_%s_%s_%s_%d.pgm', ...
                        refPersonIDs{personID}, refPoseIDs{poseID}, refExpIDs{expID}, refGlassIDs{glassID}, imSz);
                end;
                imFile = sprintf('%s/%s/%s',dataDir, refPersonIDs{personID}, fileName);
                if exist(imFile, 'file')
                    im = imread(imFile);
                    count = count + 1;
                    Data(:,count) = im(:);
                end;
            end;
        end;
    end;
end;
Data(:, count+1:end) = [];


