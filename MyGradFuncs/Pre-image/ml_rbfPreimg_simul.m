function z = ml_rbfPreimg_simul(D, K, Coeffs, sigma, x, options)
% z = ml_rbfPreimg_simul(D, K, Coeffs, sigma, x, options)
% This function computes the pre-image by optimizing a function in which we
% would like to find the pre-image z to close to x as well as the PCs in
% the feature space. In other words, we want to find z such that:
% ||phi(x) - phi(z)||^2 + C*||phi(z) - Pphi(x)||^2 is minimum.
% Inputs:
%   D: Data in column format.
%   K: Kernel matrix
%   Coeffs: Coeffs of the KPCA.
%   sigma: the kernel function has the form: exp(sigma*||x-y||^2). sigma
%       should be a negative number.
%   x: a data point; we want to find the pre-image of Pphi(x).
%   options: 
% Outputs:
%   z: the pre-image of Pphi(x).
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 13 June 07.

    [d, n] = size(D);
    mK = mean(K, 2);
    gammas = Coeffs*mK;
    cost = options.cost;
    
    if isfield(options, 'z0')
        z0 = options.z0;
    else
        z0 = x;
    end;
    z = z0;
 
    iterDiffs = [];
    objFunc = [];
    for i=1:200
        Kzx = exp(sigma*m_sqrDist(z,x));
        KzD = exp(sigma*m_sqrDist(D, z));
        A = Coeffs*KzD;
        B = (D.*repmat(KzD', d,1))*Coeffs';

        numerator = x*Kzx + cost*(D*KzD/n + B*A - B*gammas);
        denominator = Kzx + cost*(sum(KzD,1)/n + A'*A - gammas'*A);
        iterDiffs(i) = sumsqr(z - numerator/denominator);
        z = numerator/denominator;
        if (iterDiffs(i) < 1e-15), break; end;
        objFunc(i) = cmpErr(D, K, Coeffs, sigma,x,z, options.cost);
    end
    fprintf('# of iteration: %d\n', i);
    fprintf('iterDiffs: '); fprintf('%g ', iterDiffs); fprintf('\n');

    
function err = cmpErr(D, K, Coeffs, sigma, x, z, cost)
    KzD = exp(sigma*m_sqrDist(D,z));
    mK = mean(K,2);
    V = Coeffs*(KzD - mK);
    R = - 2/size(D,2)*sum(KzD) - V'*V;
    err = -2*exp(sigma*m_sqrDist(z,x)) + cost*R;