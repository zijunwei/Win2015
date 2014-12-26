function Data = ml_preprocessData(Data, shldScale, shldSubMean, shldNorm)
% Preprocess the data
% Usages:
%   Data = ml_preprocessData(Data, shldScale, shldSubMean, shldNorm)
% Inputs:
%   Data: each comlumn is an instance, rows are attributes.
%   shldScale: scale so that values of all attributes are in range [0, 1].
%       In many cases, this is to prevent a certain attribute to dominate
%       others because their values come from a larger range.
%   shldSubMean: if this is not 0, Data is normalized to have zero mean.
%   shldNorm: if this is not 0, column vectors will be scaled to have unit
%       lengths.
% Outputs:
%   Data: data after processing, if more than one processing steps are set
%       their order of execution is: scale attributes, subtract mean 
%       and scale to unit lengths.
%       The above order of steps can be different by calling
%       this function several times and setting the flags appropriately.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 29 Jan 07

[nAttrs, nInstances] = size(Data);
if shldScale %scale attributes to the same range [0,1]
    maxIm = max(Data,[],2);
    minIm = min(Data,[],2);
    range = maxIm - minIm + eps;
    Data = (Data - repmat(minIm, 1, nInstances))./repmat(range, 1, nInstances);
end
if shldSubMean %subtract the mean
    Data = Data - repmat(mean(Data,2),1, nInstances); 
end
if shldNorm %normalize so that the length of each instance vector is 1.
    aux = sqrt(sum(Data.*Data));
    Data = Data./repmat(aux, nAttrs, 1); 
end
