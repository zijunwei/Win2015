function m_matchIms(im1File, im2File)

imScl = 0.5;
minDescScl = 3;
maxDescScl = 3;
noOri = 1;

% % test SIFT
% descDir = 'G:\DataSets\Features\Caltech-101\car_side';
% load(sprintf('%s/%s.mat', descDir, ml_full2shortName(im1File)));
% desc1 = desc;
% load(sprintf('%s/%s.mat', descDir, ml_full2shortName(im2File)));
% desc2 = desc;
% CharScl1 = 3*ones([size(desc1,1), size(desc1,2)]);
% CharScl2 = 3*ones([size(desc2,1), size(desc2,2)]);

% test SIFT
tic;
[desc1, CharScl1] = ml_cmpDenseSIFT(im1File, imScl, minDescScl, maxDescScl, noOri);
toc;
tic;
[desc2, CharScl2] = ml_cmpDenseSIFT(im2File, imScl, minDescScl, maxDescScl, noOri);
toc;

% % test SURF
% tic;
% [desc1, CharScl1] = ml_cmpDenseSURF(im1File, imScl, minDescScl, maxDescScl, noOri);
% toc;
% tic;
% [desc2, CharScl2] = ml_cmpDenseSURF(im2File, imScl, minDescScl, maxDescScl, noOri);
% toc;

im1 = imread(im1File);
im1 = imresize(double(im1), imScl);
im2 = imread(im2File);
im2 = imresize(double(im2), imScl);

% BW1 = edge(im1(:,:,1),'canny');
% BW2 = edge(im2(:,:,1),'canny');

while 1
    nR = 1; nC = 2;
    subplot(nR, nC, 1); hold off; ml_imshow(im1);
%     imagesc(BW1); axis image;
    title('left-click a point you want to match, right-click to exit');
    subplot(nR, nC, 2); hold off; ml_imshow(im2);
%     imagesc(BW2); axis image;
    title('left-click two points for search region');
    fprintf('Click a point in the 1st image that you want to find matching\n');
    fprintf('Click two points in the 2nd image to define a search region\n');
    fprintf('Right click to exit\n');
    
    subplot(nR, nC, 1); 
    [x1, y1, button] = ginput(1); % get position of a point in image 1.
    x1 = round(x1);
    y1 = round(y1);
    if button ~= 1    
%         save tmp.mat;
        break;        
    end;
    hold on; scatter(x1, y1, 'or');
    scatter(x1, y1, '*c');
    siftScl1 = CharScl1(y1, x1);
    
    ucircle = rsmak('circle');
    tcircle1 = fncmb(fncmb(ucircle, 3*siftScl1*[1 0; 0 1]), [x1; y1]);
    fnplt(tcircle1);
    

    d1 = desc1(y1, x1, :);
    d1 = permute(d1, [3, 1, 2]);
    
    subplot(nR, nC, 2);
    [xs, ys] = ginput(2); % get a rectangular search region in image 2.
    xs = round(xs);
    ys = round(ys);
    xLeft = min(xs); xRight = max(xs);
    yTop = min(ys); yBottom = max(ys);
    winPos = [xLeft yTop];
    winSize = [xRight - xLeft+1, yBottom - yTop+1];
    rectangle('Position',[winPos winSize], 'EdgeColor', 'red'); 
    
    d2s = desc2(yTop:yBottom, xLeft:xRight,:);
    d2s = reshape(d2s, size(d2s,1)*size(d2s,2), size(d2s,3));
    Dist = ml_sqrDist(d1, d2s');
    [dc, idx] = min(Dist);
    [r,c] = ind2sub([winSize(2), winSize(1)], idx);
    c = c+xLeft-1;
    r = r + yTop - 1;
    hold on; scatter(c, r, 'or');
    scatter(c, r, '*c');
    siftScl2 = CharScl2(r, c); 
    tcircle2 = fncmb(fncmb(ucircle, 3*siftScl2*[1 0; 0 1]), [c; r]);
    fnplt(tcircle2);    
    
    fprintf('distance is %g\n', dc);
    fprintf('Hit any key to continute...\n');    
    pause;
end