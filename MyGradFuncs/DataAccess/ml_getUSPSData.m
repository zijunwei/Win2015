function [trainD, testD, cTestD] = ml_getUSPSData(nTrainIms, nTestIms, noiseVar, digits)
% Function 
% [trainD, testD, cTestD] = ml_getUSPSData(nTrainIms, nTestIms, noiseVar)
% This function randomly choose some train and test images. It also apply 
% some noise to the test data.
% Inputs:
%   nTrainIms: number of training images required.
%   nTestIms: number of test images requires
%   noiseVar: the noise variance of Gaussian additive noise that want to
%       add to the test images.
%   digits: the digit class you want to get, e.g. digits = [1, 7] getting digits 1 and 7 only.
% Outputs:
%   trainD: train data, each column is a data instance.
%   testD: noisy test data.
%   cTestD: clean test data, correspond to testD.
%
% By: Minh Hoai Nguyen
% Date: 8 May 07
% Last modified: 1 Aug 2013


load('/Volumes/LaCie/DataSets/USPS/USPS-MATLAB-train.mat', 'samples', 'labels');   
samples = max(samples(:)) - samples; %inverse black<->white.
samples = ml_preprocessData(samples, 1, 0, 0);

labels = labels';
[trainD, testD, cTestD] = deal(cell(1, 10));

for i=digits
    iIdxes = find(labels == i);
    ranNums = randperm(size(iIdxes,2));
    trainD{i} = samples(:, iIdxes(ranNums(1:nTrainIms)));
    cTestD{i} = samples(:, iIdxes(ranNums(1+nTrainIms:nTrainIms+nTestIms)));

    for j=1:nTestIms
        im = reshape(samples(:, iIdxes(ranNums(nTrainIms+j))), 16,16);
        im = imnoise(im, 'gaussian', 0, noiseVar);
        testD{i}(:,j) = im(:);
    end;
end;

trainD = cat(2, trainD{:});
testD  = cat(2, testD{:});
cTestD = cat(2, cTestD{:});