classdef ML_SvmAsgd
% Matlab implementation of Leon Bottou svmasgd function (Average SGD)
% This performs reasonable on classification task, but poorly for optimization
%   On my test set of human action recognition with dense trajectory
%   The ap is often lower (not much) than LibSVM
%   The objective value is always higher (quite a lot) than the objective of LibSVM
%   Also, this is twice slower than ML_SvmSgd, and doesn't seem to have much benefit over ML_SvmSgd
% By: Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Created: 01-Aug-2013
% Last modified: 01-Aug-2013
    
    methods (Static)
        
        % minimize_{w,b} 0.5*lambda ||w||^2 + 1/n*sum_i xi_i
        %           s.t  y_i*(w'*x_i + b) >= 1 - xi_i;
        %                xi_i >= 0
        % nEpoch: number of rounds running over the entire data
        function [aw,ab] = train(D, lb, lambda, nEpoch, shldDisp) 
            % shuffle the data
            idxs = randperm(size(D,2));
            D  = D(:, idxs);
            lb = lb(idxs);
            
            % use subset of data for determine eta0
            idxs = randsample(size(D,2), min(size(D,2), 1000));          
            dw = ones(length(lb), 1);
            eta0 = ML_SvmSgd.determineEta0(D(:,idxs), lb(idxs), dw(idxs), lambda);
            mu0 = 1;
            
            if ~exist('nEpoch', 'var') || isempty(nEpoch)
                nEpoch = 1000;
            end
            if ~exist('shldDisp', 'var') || isempty(shldDisp)
                shldDisp = 0;
            end;
            
            [w, aw] = deal(zeros(size(D,1),1)); % weight and average weigth
            b = 0; ab = 0; % bias
            wDivisor = 1; awDivisor = 1; wFraction = 0; 
            t = 1; tstart = size(D, 2);
            for epoch=1:nEpoch                
                for i=1:size(D,2)
                    eta = eta0/((1 + lambda*eta0*t)^0.75);
                    if t <= tstart
                        mu = 1;
                    else
                        mu = mu0/(1 + mu0*(t-tstart));
                    end
                    
                    [w, b, aw, ab, wDivisor, awDivisor, wFraction] = ...
                        ML_SvmAsgd.trainone(w, b, aw, ab, wDivisor, awDivisor, wFraction, ...
                                           D(:,i), lb(i), lambda, eta, mu);
                    t = t+1;                
                end;
                
                if mod(epoch, 100) == 0 && shldDisp
                    obj = ML_SvmSgd.getSvmObj(D, lb, lambda, aw/awDivisor + w*wFraction/awDivisor, ab);
                    fprintf('SvmAsgd epoch %d, obj: %.5f\n', epoch, obj);
                end
            end;
            
            aw = aw/awDivisor + w*wFraction/awDivisor;
        end
        
        % train for a single data point
        % b, ab: bias and average bias terms
        % The current weight vector is: w/wDivisor
        % The average weight vector is: aw/awDivisor + w*wFraction/awDivisor
        function [w, b, aw, ab, wDivisor, awDivisor, wFraction] = ...
                trainone(w, b, aw, ab, wDivisor, awDivisor, wFraction, x, y, lambda, eta, mu)
            
            if wDivisor > 1e5 || awDivisor > 1e5 
                aw = aw/awDivisor + w*wFraction/awDivisor;                
                w = w/wDivisor;
                
                wDivisor  = 1;
                awDivisor = 1;
                wFraction = 0;                
            end;
            
            score = (w'*x)/wDivisor + b;            
            wDivisor = wDivisor/(1 - eta*lambda);
            if score*y < 1                                
                etd = y*eta*wDivisor;
                w = w + x*etd;
                
                etab = eta*0.01;
                b = b + y*etab;
            else
                etd = 0;
            end;
            
            % averaging
            if mu >=1 
                aw(:) = 0; 
                awDivisor = wDivisor;
                wFraction = 1;
                ab = b;
            elseif mu > 0
                if etd ~= 0
                    aw = aw - wFraction*etd*x;
                end
                awDivisor = awDivisor/(1-mu);
                wFraction = wFraction + mu*awDivisor/wDivisor;
                
                ab = ab + mu*(b - ab);
            end            
        end;
    end    
end

