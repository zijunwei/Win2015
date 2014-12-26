function z = ml_rbfPreimg(D, x, sigma, energy, method, options)
% z = ml_rbfPreimg(D, x, sigma, energy, method, options)
% Compute the pre-image.
% Inputs:
%   D: Data in column format.
%   x: Data point in the input space which we want to find the pre-image of
%       Pphi(x). 
%   sigma: The kernel function is exp(sigma*||x-y||^2), sigma should be a 
%       negative number.
%   energy: The energy that should be preserved by KPCA.
%   method: What method to use to compute the pre-image. method could be
%       one of the following: 'mika', 'kwok', 'kwok2', 'kwork_wght',
%       'minh3', 'minh4', 'simul'.
%   options: additional options.
%       options.z0: the initial position for searching in some methods.
%       options.noisyZ: this one should be x.
%       options.cost: the C variable used in simultaneous optimization
%       method, this is only used when method is set to 'simul'.
% Output:
%   z: a data point in the input space that corresponds to pre-image of
%       Pphi(x).
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 14 June 07.

n = size(D, 2);
    
% Compute the coefficients for KPCA.
K = exp(sigma*ml_sqrDist(D, D)); %kernel matrix.
Coeffs = ml_kpca(ml_centralizeKernel(K), energy, 1); %Coeffs in the centralized coord
Coeffs = Coeffs - repmat(mean(Coeffs,2), 1, n); %Coeffs wrt to the original coordinates.

if ~exist(options, 'var') || isempty(options) 
    options.z0 = x;
    options.noisyZ = x;
    % options.cleanZ = cleanX(:,t);
    options.cost = 10;
end;


if strcmp(method, 'simul')
    z = ml_rbfPreimg_simul(D, K, Coeffs, sigma, x, options);    
else
    KxD = exp(sigma*ml_sqrDist(D, x)); 
    mK = mean(K, 2); 
    betas = Coeffs*(KxD - mK);
    lambdas = Coeffs'*betas + 1/n;  

    z = ml_rbfPreimg_dp(D, K, sigma, lambdas, method, options);
end;

