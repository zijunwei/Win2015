function z = m_rbfPreimg_kwok_wght(D, K, sigma, lambdas, options)
% Implementation of Kwok's algorithm for finding pre-image
% The method is described in the paper
% "The Pre-Image Problem in Kernel Methods" Kwok & Tsang, Neural Net 2004.
% However the entries x_i is weighted based their distance to Pphi(x).
%
% By Minh Hoai Nguyen
% Last modified: 27 Apr 07

    aux = K*lambdas; %dot product of Pphi(x) with phi(x_i) in feature space
    x = options.noisyZ;
    KxPx = exp(sigma*m_sqrDist(x,D))*lambdas; %<phi(x), Pphi(x)>
    dx2 = 1/sigma*log(KxPx); %||z-x||^2
    
%     wghts = aux;
    wghts = aux.^(-1/sigma);    
    valIdxes = logical((aux <=1).*(aux >0));
    aux = aux(valIdxes);
    wghts = wghts(valIdxes);
    D = D(:,valIdxes);
    
    desSqrDist = 1/sigma*log(aux); %desired sqr dist from z to x_i, i=1,...,n

    
    [srDesSqrDist, idxes] = sort(desSqrDist);
    if isfield(options, 'nNNs');
        nNNs = options.nNNs;
    else
        nNNs = 10;
    end;
    nNNs = min(nNNs, length(aux));
    idxes = idxes(1:nNNs);    
    wghts = wghts/sum(wghts);
%     z = addPoint(D(:,idxes), desSqrDist(idxes), wghts(idxes));
    z = addPoint2(D(:,idxes), desSqrDist(idxes), x, dx2, wghts(idxes));

function z = addPoint2(D, desSqrDist, x, dx2, wghts)
    n = size(D,2);
    D = D - repmat(x, 1, n);
    X2 = sum(D.*D,1)';
    aux = wghts.*(X2 - desSqrDist + dx2)/2; %because aux(i) = (dx2 + (x_i-x)^2 - d_i^2)/2;
    WD = D.*repmat(wghts',size(D,1),1);
    dx = m_pinv(WD', 1e-5)*aux;
    z = dx + x;
    
    
function z = addPoint(D, desSqrDist, wghts)
    mWD = D*wghts/sum(wghts); 
    n = size(D,2);
    D = D - repmat(mWD, 1, n); % Center data, note: not weighed data
    X2 = sum(D.*D,1)'; %weighted sqr length of x_i
    z2 = wghts'*(desSqrDist - X2)/sum(wghts); %weighted sqr(z)
    aux = wghts.*(X2 - desSqrDist + z2)/2; %because aux(i) = (z^2 + x_i^2 - d_i^2)/2;
     
    %We solve the equation D'*z = aux for z.
%     z = pinv(repmat(wghts,1,size(D,1)).*D')*aux;
    z = m_pinv(repmat(wghts,1,size(D,1)).*D', 1e-10)*aux;
    %Move back to original coordinate
    z = z + mWD;
    

