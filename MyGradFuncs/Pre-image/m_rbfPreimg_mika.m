function z = m_rbfPreimg_mika(D, K, sigma, lambdas, options)
% Implementation of fixed point algorithm for finding pre-image. 
% The algorithm is described in Mika, Scholkopf and Smola's NIPS 99 paper.
% By Minh Hoai Nguyen
% Last modified: 27 Apr 07
    nMaxRestart = 5;
    NNs = m_getNNs(D, K, lambdas, nMaxRestart);
    if isfield(options, 'z0')
        startPnts = [options.z0, NNs];
    else
        startPnts = NNs;
    end;

    z = [];
    for i=1:size(startPnts)
        if ~isempty(z), break; end;
        if (i > 2), fprintf('===>Restart with new starting position\n'); end;
        z0 = startPnts(:,i);
        [z, iterDiffs, iterErrs] = mikaHelper(D, K, sigma, lambdas, z0);
    end;
    
    if isempty(z)
        fprintf('WARNING: cannot find a good pre-image');
        z = startPnts(:,1);
    end;
        
    fprintf('Mika method, # of iters: %d\n', size(iterDiffs,2));
    fprintf('  iterDiffs: '); fprintf('%g ', iterDiffs); fprintf('\n');
    fprintf('  iterErrs: '); fprintf('%g ', iterErrs); fprintf('\n');

function [z, iterDiffs, iterErrs] = mikaHelper(D, K, sigma, lambdas, z0)
    z = z0;
    iterDiffs = [];
    iterErrs = [];
    for i=1:200
        KzD = exp(sigma*ml_sqrDist(D, z));
        etas = lambdas.*KzD;
        numerator = D*etas;        
        denominator = sum(etas);
        
        if denominator == 0 
           z = []; break;         
        end;
        iterDiffs(i) = sumsqr(z - numerator/denominator);        
        iterErrs(i) = m_cmpErr(D, K, sigma, lambdas, z);
        z = numerator/denominator;        
        if (iterDiffs(i) < 0.00001), break; end;
    end 