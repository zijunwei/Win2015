classdef ML_SvmSgd
% Matlab implementation of Leon Bottou svmsgd function
% This performs reasonable on classification task, but poorly for optimization
% On my test set of human action recognition with dense trajectory
%   The ap is often lower (not much) than LibSVM
%   The objective value is always higher (quite a lot) than the objective of LibSVM
% By: Minh Hoai Nguyen (minhhoai@robots.ox.ac.uk)
% Created: 01-Aug-2013
% Last modified: 01-Aug-2013

    methods (Static)
        function main()
            n = 100; % number of train
            m = 300; % number of test
            [PosTrD, PosTstD] = ml_getUSPSData(n, m, 0, 1:5);
            [NegTrD, NegTstD] = ml_getUSPSData(n, m, 0, 6:10);
            TrD = [PosTrD, NegTrD];
            trLb = [ones(size(PosTrD,2),1); - ones(size(NegTrD, 2),1)];
            
            TstD = [PosTstD, NegTstD];
            tstLb = [ones(size(PosTstD,2),1); - ones(size(NegTstD, 2),1)];
            C = 0.01;
            lambda = 1/C/size(TrD,2);
            
            dw = ones(length(trLb), 1);
            ML_SvmSgd.evaluateEta(TrD, trLb, dw, lambda, 4);            
            
            [w, b] = ML_SvmSgd.train(TrD, trLb, dw, lambda, 50, 1);            
            obj = ML_SvmSgd.getSvmObj(TrD, trLb, dw, lambda, w, b);            
            svmscore = TstD'*w + b;            
            acc = sum(svmscore.*tstLb >= 0)/length(tstLb);
            
            [w1, b1] = ML_SvmAsgd.train(TrD, trLb, lambda, 50, 1);            
            obj1 = ML_SvmSgd.getSvmObj(TrD, trLb, dw, lambda, w1, b1);            
            svmscore = TstD'*w1 + b1;            
            acc1 = sum(svmscore.*tstLb >= 0)/length(tstLb);
            
            
            svmModel = svmtrain(trLb, TrD', sprintf('-t 0 -c %g -q', C));
            b2 = - svmModel.rho*svmModel.Label(1);
            w2 = svmModel.SVs'*svmModel.sv_coef*svmModel.Label(1);
            svmscore2 = TstD'*w2 + b2;
            acc2 = sum(svmscore2.*tstLb >= 0)/length(tstLb);
            obj2 = ML_SvmSgd.getSvmObj(TrD, trLb, dw, lambda, w2, b2);
            
            fprintf('(libSVM, sgd, asgd), acc: (%.3f %.3f %.3f), obj: (%.5f %.5f %.5f)\n', ...
                acc2, acc, acc1, obj2, obj, obj1);
        end;
        
        % nEpoch: number of rounds running over the entire data
        % minimize_{w,b} 0.5*lambda ||w||^2 + 1/n*sum_i xi_i
        %           s.t  y_i*(w'*x_i + b) >= 1 - xi_i;
        %                xi_i >= 0
        % dw: instance weights
        function [w,b] = train(D, lb, dw, lambda, nEpoch, shldDisp) 
            startT = tic;
            % shuffle the data
            idxs = randperm(size(D,2));
            D = D(:, idxs);
            lb = lb(idxs);
            
            % use subset of data for determine eta0
            idxs = randsample(size(D,2), min(size(D,2), 1000));            
            eta0 = ML_SvmSgd.determineEta0(D(:,idxs), lb(idxs), dw(idxs), lambda);
            
            if ~exist('nEpoch', 'var') || isempty(nEpoch)
                nEpoch = 1000;
            end
            if ~exist('shldDisp', 'var') || isempty(shldDisp)
                shldDisp = 0;
            end;
            
            if ~exist('dw', 'var') || isempty(dw)
                dw = ones(length(lb),1);
            end;
            
            wDivisor = 1;
            w = zeros(size(D,1),1);
            b = 0;
            t = 1;
            for epoch=1:nEpoch                
                for i=1:size(D,2)
                    eta = eta0/(1 + lambda*eta0*t);
                    [w, b, wDivisor] = ML_SvmSgd.trainone(w, b, wDivisor, D(:,i), lb(i), dw(i), lambda, eta);
                    t = t+1;                
                end;
                
                if mod(epoch, 100) == 0 && shldDisp
                    obj = ML_SvmSgd.getSvmObj(D, lb, dw, lambda, w/wDivisor, b);
                    fprintf('SvmSgd epoch %5d, obj: %.7f, elapseT: %6.0fs\n', epoch, obj, toc(startT));
                end
            end;
            w = w/wDivisor;
        end

        
        % train for a single data point
        % xw: weight for data x
        function [w, b, wDivisor] = trainone(w, b, wDivisor, x, y, xw, lambda, eta)
            score = (w'*x)/wDivisor + b;
            wDivisor = wDivisor/(1 - eta*lambda);
            if wDivisor > 1e5
                w = w/wDivisor;
                wDivisor = 1;
            end;
            
            if score*y < 1                
                w = w + y*eta*wDivisor*x*xw;
                etab = eta*0.01;
                b = b + y*etab*xw;
            end            
        end;
        
        
        function cost = getSvmObj(D, lb, dw, lambda, w, b)
            svmScore = D'*w + b;
            xi = max(0, 1 - lb.*svmScore);
            loss = dw'*xi;
            cost = loss/size(D,2) + 0.5*lambda*sum(w.^2);
        end;
        
        function cost = evaluateEta(D, lb, dw, lambda, eta)
            w = zeros(size(D,1),1);
            b = 0;
            wDivisor = 1;
            for i=1:size(D,2)
                [w, b, wDivisor] = ML_SvmSgd.trainone(w, b, wDivisor, D(:,i), lb(i), dw(i), lambda, eta);
            end;
            w = w/wDivisor;            
            cost = ML_SvmSgd.getSvmObj(D, lb, dw, lambda, w, b);  
        end;
        
        
        % dw: instance weights
        function eta0 = determineEta0(D, lb, dw, lambda)
            factor = 2;
            loEta = 1;
            loCost = ML_SvmSgd.evaluateEta(D, lb, dw, lambda, loEta);
            hiEta = loEta*factor;
            hiCost = ML_SvmSgd.evaluateEta(D, lb, dw, lambda, hiEta);
            if (loCost < hiCost)
                while loCost < hiCost
                    hiEta = loEta;
                    hiCost = loCost;
                    loEta = hiEta/factor;
                    loCost = ML_SvmSgd.evaluateEta(D, lb, dw, lambda, loEta);
                end
            elseif hiCost < loCost
                while hiCost < loCost
                    loEta = hiEta;
                    loCost = hiCost;
                    hiEta = loEta*factor;
                    hiCost = ML_SvmSgd.evaluateEta(D, lb, dw, lambda, hiEta);
                end                
            end
            eta0 = loEta;
            fprintf('# using eta0= %g\n', eta0);            
        end
    end    
end

