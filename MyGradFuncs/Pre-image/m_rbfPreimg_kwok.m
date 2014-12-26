function z = m_rbfPreimg_kwok(D, K, sigma, lambdas, options)
% Implementation of Kwok's algorithm for finding pre-image
% The method is described in the paper
% "The Pre-Image Problem in Kernel Methods" Kwok & Tsang, Neural Net 2004.
% By Minh Hoai Nguyen
% Last modified: 27 Apr 07

    aux = K*lambdas; %dot product of Pphi(x) with phi(x_i) in feature space
    desSqrDist = 1/sigma*log(aux); %desired sqr dist from z to x_i, i=1,...,n

    [srDesSqrDist, idxes] = sort(desSqrDist);
    if isfield(options, 'nNNs');
        nNNs = options.nNNs;
    else
        nNNs = 10;
    end;
    idxes = idxes(1:nNNs);    
    z = addPoint(D(:,idxes), desSqrDist(idxes));

function z = addPoint(D, desSqrDist)
    mD = mean(D, 2); 
    n = size(D,2);
    D = D - repmat(mD, 1, n); %Center data
    X2 = sum(D.*D,1)'; %Sqr length of x_i
    z2 = 1/n*(sum(desSqrDist) - sum(X2)); %sqr(z)
    aux = (X2 - desSqrDist + z2)/2; %because aux(i) = (z^2 + x_i^2 - d_i^2)/2;
     
    %We solve the equation D'*z = aux for z.
    z = pinv(D')*aux;
    
    %Move back to original coordinate
    z = z + mD;