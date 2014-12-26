function ml_cmpDenseSIFT_lot(dataDir, outDir, imScl, minSiftScl, maxSiftScl, noOrient)


imFiles = ml_getFilesInDir(dataDir, 'bmp');

for i=1:length(imFiles);
    fprintf('compute SIFT_%g descriptor for %d/%d image %s\n', ...
        imScl, i, length(imFiles), imFiles{i});
    desc = ml_cmpDenseSIFT(imFiles{i}, imScl, minSiftScl, maxSiftScl, noOrient);
    save(sprintf('%s/%s.mat', outDir, ml_full2shortName(imFiles{i})), 'desc');
end;