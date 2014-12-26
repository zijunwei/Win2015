function [z, err] = ml_rbfPreimg_dp(D, K, sigma, lambdas, method, options)
% m_rbfPreimg_dp: fining pre-image for projection in principal subspace in
%   kPCA. This implements several methods for finding pre-image for radial
%   basis function. This function check the method option and dispatch the
%   request to appropriate function. dp stands for 'dispatch'.
% Inputs:
%   D: The data matrix
%   K: The kernel matrix (not centralized)
%   sigma: the kernel function is exp(sigma*||x-y||^2); sigma should be a
%       negative number.
%   lambdas: the coeffs of the vector in the feature space that we want to
%       find the preimage for. y = sum(lambdas(i)*phi(x_i))
%   method: method to find pre-image. method could be one of the following
%       types: 'mika', 'kwok', 'kwok2', 'kwok_wght', 
%       'minh3', 'minh4', 'nearest'
% Ouptuts:
%   z: the preimage of Pn(phi(x)).
% By Minh Hoai Nguyen.
% Date: 13 June 07
    
    if strcmp(method, 'mika')
        z = m_rbfPreimg_mika(D, K, sigma, lambdas, options);
    elseif strcmp(method, 'kwok')
        z = m_rbfPreimg_kwok(D, K, sigma, lambdas, options);
    elseif strcmp(method, 'kwok2')
        z = m_rbfPreimg_kwok2(D, K, sigma, lambdas, options);
    elseif strcmp(method, 'kwok_wght')
        z = m_rbfPreimg_kwok_wght(D, K, sigma, lambdas, options);   
    elseif strcmp(method, 'nearest')
        z = m_getNNs(D, K, lambdas, 1);
    elseif strcmp(method, 'minh3')
        z = m_rbfPreimg_minh3(D, K, sigma, lambdas);
    elseif strcmp(method, 'minh4')
        z = m_rbfPreimg_minh4(D, K, sigma, lambdas, options);
%     elseif strcmp(method, 'minh')
%         z = rbfPreimg_minh(D, K, sigma, lambdas, options);
%     elseif strcmp(method, 'minh2')
%         z = rbfPreimg_minh2(D, K, sigma, lambdas, options);
    end;
    err = m_cmpErr(D, K, sigma, lambdas, z);    
    
    
    
% function z = rbfPreimg_minh2(D, K, sigma, lambdas, options)
% % Minh2: moving closer using Kwok method.
%     alpha = 0.9;    
%     nMaxRestart = 1;
%     
%     NNs = m_getNNs(D, K, lambdas, nMaxRestart);
%     if isfield(options, 'z0')
%         startPnts = [options.z0, NNs];
%     else
%         startPnts = NNs;
%     end;
% 
%     Zs = zeros(size(startPnts));
%     finalErrs = zeros(1, size(startPnts,2));
%     for j = 1:size(startPnts,2)
%         z = startPnts(:, j);   
%         iterErrs = cmpErr(D, K, sigma, lambdas, z);
%         for i=1:10
%             KzD = exp(sigma*m_sqrDist(D, z));
%             lambdaTs = (options.invK)*KzD;
%             lambdaTs = alpha*lambdaTs + (1-alpha)*lambdas;                        
%             z2 = m_rbfPreimg_kwok(D, K, sigma, lambdaTs, options);            
%             err = cmpErr(D, K, sigma, lambdas, z);
%             if (err < iterErrs(i))
%                 z = z2;
%                 iterErrs(i+1) = err;
%             else
%                 break;
%             end;
%         end;
%         Zs(:,j) = z;
%         finalErrs(j) = m_cmpErr(D, K, sigma, lambdas, z);
% %         fprintf('Minh method:\n');
% %         fprintf('  iterDiffs: %g ', iterDiffs); fprintf('\n');
% %         fprintf('  iterErrs: %g ', iterErrs); fprintf('\n');
%     end;
%     
%     [minErr, idx] = min(finalErrs);
%     z = Zs(:,idx);
%     fprintf('Minh2 method, min error index: %d\n', idx);
%     
%     
% function z = rbfPreimg_minh(D, K, sigma, lambdas, options)
% % Minh, moving closer using iterative method.
%     KxD = K*lambdas;
%     alpha = 0.5;    
%     nMaxRestart = 10;
%     
%     NNs = m_getNNs(D, K, lambdas, nMaxRestart);
%     if isfield(options, 'z0')
%         startPnts = [options.z0, NNs];
%     else
%         startPnts = NNs;
%     end;
% 
%     Zs = zeros(size(startPnts));
%     finalErrs = zeros(1, size(startPnts,2));
%     for j = 1:size(startPnts,2)
%         z = startPnts(:, j);   
% %         iterDiffs = [];
% %         iterErrs = [];
%         for i=1:10
%             KzD = exp(sigma*m_sqrDist(D, z));
%             lambdaTs = (options.invK)*KzD;
%             lambdaTs = alpha*lambdaTs + (1-alpha)*lambdas;
%             aux = alpha*KzD + (1-alpha)*KxD; %y_t'*phi(x_j)
%             numerator = D*(aux.*lambdaTs);
%             denominator = lambdaTs'*aux;
%             iterDiffs(i) = sumsqr(z - numerator/denominator);  
%             iterErrs(i) = m_cmpErr(D, K, sigma, lambdas, z);
%             z = numerator/denominator;
%         end;
%         Zs(:,j) = z;
%         finalErrs(j) = cmpErr(D, K, sigma, lambdas, z);
% %         fprintf('Minh method:\n');
% %         fprintf('  iterDiffs: %g ', iterDiffs); fprintf('\n');
% %         fprintf('  iterErrs: %g ', iterErrs); fprintf('\n');
%     end;
%     
%     [minErr, idx] = min(finalErrs);
%     z = Zs(:,idx);
%     fprintf('Minh method, min error index: %d\n', idx);
% 
%     
%     
%     
% 
%     
%       
%     
% function z = addPoint3(D, desSqrDist, wghts, k)
%     if ~exist('wghts', 'var')
%         wghts = ones(size(desSqrDist));
%     end;
%     wghts = wghts/sum(wghts);
% 
%     [d, n] = size(D);
%     [desSqrDist, idxes] = sort(desSqrDist);
%     D = D(:,idxes);
%     wghts = wghts(idxes);
%     
%     w1K = sum(wghts(1:k));
%     mDk = D(:,1:k)*wghts(1:k)/w1K;
%     D = D - repmat(mDk, 1, n); %center data
%     X2 = sum(D.*D,1)'; %sqr lenght of x_i;
%     z2 = wghts(1:k)'*(desSqrDist(1:k) - X2(1:k))/w1K; %sqr(z);
%     aux = wghts.*(X2 + z2 - desSqrDist)/2; %aux(i) = (z^2 + x_i^2 - d_i^2)/2;
%     
%     D = repmat(wghts',d,1).*D;
%     
%     %We solve the equation D'*z = aux for z.
%     z = pinv(D*D')*(D*aux); %Solution with smallest norm.
%     %z = D'\aux; %sparse solution.    
% %     z = lsqlin(D', aux, [], [], [], [], -mDk, 1 - mDk); %constrained
%     
%     %Move back to original coordinate
%     z = z + mDk;