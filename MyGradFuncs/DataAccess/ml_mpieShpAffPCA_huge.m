function ml_mpieShpAffPCA_huge(LmPts, scl, m, pcaMode, lmPtIdxs)
% ml_mpieShpAffPCA_huge(LmPts, scl, k, pcaMode)
% This function compute shape subspace for MPIE database. It first compute 
% the mean shape. For each of particular shape this function compute the 
% transformation parameters that will bring the mean shape to that shape 
% as close as possible in least square error sense.
% Inputs:
%   LmPts: 136*n matrix, landmarks for n faces.
%   scl: the scale factor
%   m, pcaMode: if pcaMode is 1, m is a real number from 0 to 1 indicates
%       the desize energy. If pcaMode is not 1, m is the number of desire
%       principle components.
%   lmPtIdxs: images in MPIE database has 68 landmarks, however, if
%       lmPtIdxs is not empty, this function will align using only the
%       landmark points specified by indexes in lmPtIdxs.
% Outputs:
%   This function does not return value, it however save the following
%       variables in the files with the same names in directory './tmp/'
%   mShape: the mean shape, this is a 136*1 matrix.
%   AlgnParams: Each column v = AlgnParams(:,i) is a 6-vector that defines 
%       6 affine transformation parameters. The matrix
%       M = [v(1) v(2) v(3); v(4) v(5) v(6); 0 0 1] is the matrix that
%       will bring the mean shape (after adding some shape variation) to 
%       the shape defined by landmark file i_th [x';y';1] = M*[x; y; 1];
%   NRAlgnParams: align params for non-rigid transformation. Each column 
%       u = NRAlgnParams(:,i) is a vector that defines nonrigid
%       transformation parameters. 
%   AlgnShps: each comlumn is a shape vector after warping a particular
%       shape to the mean shape using affine transformation.
%   ShpBasis: The basis of shape variation.
%
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 16 June 07

if ~exist('scl','var')
    scl = 1;
end;

if ~exist('lmPtIdxs', 'var') || isempty(lmPtIdxs)
    lmPtIdxs = 1:68;
end;

LmPts = scl*LmPts;
LmPts_k = LmPts([lmPtIdxs, 68 + lmPtIdxs],:);

k = length(lmPtIdxs); %number of landmark points used.
n = size(LmPts,2);
mShape = mean(LmPts, 2); % the mean shape of 68-landmark shapes.
mShape_k = mean(LmPts_k,2); % The mean shape of the landmarks used for alignment only.
mShape_k = [mShape_k(1:k), mShape_k(1+k:end), ones(k,1)];


A = inv(mShape_k'*mShape_k);

btchSz = 90000;
% btchSz = 250;
nBtchs = ceil(n/btchSz);

mkdir('./tmp');
save('./tmp/LmPts_tmp.mat', 'LmPts', 'LmPts_k');
save('./tmp/mShape.mat', 'mShape');
clear LmPts LmPts_k;

for i=1:nBtchs
    fprintf('Process batch: %d\n',i);
    if i==nBtchs
        idxs = 1+(i-1)*btchSz:n;
    else
        idxs = 1+(i-1)*btchSz:i*btchSz;        
    end;
    load('./tmp/LmPts_tmp.mat', 'LmPts', 'LmPts_k');
    LmPts = LmPts(:,idxs);
    LmPts_k = LmPts_k(:,idxs);
    processBatch(LmPts, LmPts_k, A, mShape_k, k, i);    
    clear LmPts LmPts_k;
end;

fprintf('Combining batches\n');

cmbnAlgnParams(btchSz, nBtchs, n);
cmbnAlgnShps(btchSz, nBtchs, n, m, pcaMode);
cleanTmpFiles(nBtchs);


function processBatch(LmPts, LmPts_k, A, mShape_k, k, btchNo)    
    AlgnShps = zeros(136, size(LmPts,2));
    AlgnParams = zeros(6, size(LmPts,2));
    for i=1:size(LmPts,2)
        if mod(i,1000) == 0
            fprintf('Affine: process image %d\n', i);
        end;
        % M is the 3*3 affine transformation matrix that transforms the
        % mean shape to the shape defined by landmark file i_th.
        M = ([LmPts_k(1:k,i)'; LmPts_k(1+k:end,i)'; ones(1,k)]*mShape_k)*A;
        AlgnParams(:,i) = [M(1,:)'; M(2,:)'];
        pts = reshape(LmPts(:,i),68,2);    
        aPts = inv(M)*[pts'; ones(1, size(pts,1))];
        AlgnShps(:,i) = [aPts(1,:)'; aPts(2,:)'];    
    end;
    save(sprintf('./tmp/AlgnShpsParams_%d_tmp.mat',btchNo), 'AlgnShps', 'AlgnParams');

function cmbnAlgnParams(btchSz, nBtchs, n)
    fprintf('Combining AlgnParams\n');
    bigAlgnParams = zeros(6, n);
    
    for i=1:nBtchs
        if i==nBtchs
            idxs = 1+(i-1)*btchSz:n;
        else
            idxs = 1+(i-1)*btchSz:i*btchSz;        
        end;
        
        load(sprintf('./tmp/AlgnShpsParams_%d_tmp.mat',i), 'AlgnParams');
        bigAlgnParams(:,idxs) = AlgnParams;
        clear AlgnParams;
    end;
    AlgnParams = bigAlgnParams;
    save('./tmp/AlgnParams.mat', 'AlgnParams');
    
function cmbnAlgnShps(btchSz, nBtchs, n, m, pcaMode)
    fprintf('Combining AlgnShps\n');
    bigAlgnShps = zeros(136, n);
    
    for i=1:nBtchs
        if i==nBtchs
            idxs = 1+(i-1)*btchSz:n;
        else
            idxs = 1+(i-1)*btchSz:i*btchSz;        
        end;
        
        load(sprintf('./tmp/AlgnShpsParams_%d_tmp.mat',i), 'AlgnShps');
        bigAlgnShps(:,idxs) = AlgnShps;
        clear AlgnShps;
    end;
    AlgnShps = bigAlgnShps; 
    clear bigAlgnShps;
    save('./tmp/AlgnShps.mat', 'AlgnShps');  
    load('./tmp/mShape.mat');
    

    % Centralize Shps in batches.    
	btchSz = 50000;
    nBtchs = ceil(n/btchSz);    
    for i=1:nBtchs
        if i==nBtchs
            idxs = 1+(i-1)*btchSz:n;
        else
            idxs = 1+(i-1)*btchSz:i*btchSz;        
        end;
        AlgnShps(:,idxs) = AlgnShps(:,idxs) - ...
            repmat(mShape, 1, length(idxs)); 
    end;
    
    [ShpBasis, sVals, NRAlgnParams] = ml_pca2(AlgnShps, m, pcaMode);
    save('./tmp/ShpBasis.mat', 'ShpBasis');       
    save('./tmp/NRAlgnParams.mat', 'NRAlgnParams');

function cleanTmpFiles(nBtchs)
    fprintf('Cleaning up\n');
    for i=1:nBtchs
        delete(sprintf('./tmp/AlgnShpsParams_%d_tmp.mat',i));
    end;
    