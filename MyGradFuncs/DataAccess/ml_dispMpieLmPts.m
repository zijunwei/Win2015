function ml_dispMpieLmPts()
% Display locations of landmark points used in MPIE database.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 26 Dec 08

load('/Users/hoai/DataSets/multipie/lm_surprise/100_02_02_051_05_lm.mat');
scatter(pts(:,1), pts(:,2), '+r');
axis image ij;

for i=1:size(pts,1)
    text(pts(i,1), pts(i,2), sprintf('    %d', i));
end;
