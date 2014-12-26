function z = m_rbfPreimg_kwok2(D, K, sigma, lambdas, options)
% Kwok's algorithm for finding pre-image is described in the paper
% "The Pre-Image Problem in Kernel Methods" Kwok & Tsang, Neural Net 2004.
% This function is a modification of Kwok's method. In the vanila version
% of Kwok & Tsang method, 10 nearest neighbours are used as reference
% vector to compute the image. The problem arises when some reference
% vectors are linear combinations of other reference vectors. If that
% occurs the system of linear equation might not have solution and the
% approximated solution might be bad. This function makes sure the
% reference data points are linearly independent.
%
% By Minh Hoai Nguyen
% Last modified: 13 June 07

    aux = K*lambdas; %dot product of Pphi(x) with phi(x_i) in feature space
    desSqrDist = 1/sigma*log(aux); %desired sqr dist from z to x_i, i=1,...,n

    [srDesSqrDist, idxes] = sort(desSqrDist);
    if isfield(options, 'nNNs');
        nNNs = options.nNNs;
    else
        nNNs = 10;
    end;
    
    refIdxes = idxes(1); % Indexes of reference vectors.
    for j=2:nNNs
        if rank(D(:,[refIdxes, idxes(j)])) > length(refIdxes)
            refIdxes = [refIdxes, idxes(j)];
        end;        
    end;
    
    z = addPoint2(D(:,refIdxes), desSqrDist(refIdxes));

function z = addPoint(D, desSqrDist, z0)
    mD = mean(D, 2);
    n = size(D,2);
    D = D - repmat(mD, 1, n); %Center data
    X2 = sum(D.*D,1)'; %Sqr length of x_i
    z2 = 1/n*(sum(desSqrDist) - sum(X2)); %sqr(z)
    aux = (X2 - desSqrDist + z2)/2; %because aux(i) = (z^2 + x_i^2 - d_i^2)/2;
     
    % we need to solve for z: D'*(z - mD) = aux;
    % or D'*(z -mD -z0 +z0) = aux;
    % or D'*(z - z0) = aux + D'*(mD - z0);
    aux = aux + D'*(mD - z0);
%     z1 = pinv(D')*aux;
    z1 = m_pinv(D', 1e-1)*aux;
    z = z1 + z0;

function z = addPoint2(D, desSqrDist)
    mD = D(:,1);
    n = size(D,2);
    D = D - repmat(mD, 1, n); %Center data
    X2 = sum(D.*D,1)'; %Sqr length of x_i
    z2 = desSqrDist(1);
    aux = (X2 - desSqrDist + z2)/2; %because aux(i) = (z^2 + x_i^2 - d_i^2)/2;
     
%     z1 = pinv(D')*aux;
    z1 = m_pinv(D', 1e-5)*aux;
    z = z1 + mD;

