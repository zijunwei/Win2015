function Ws = ml_multiSVM_svmstruct(D, lb, C, option)
% function Ws = ml_multiSVM_svmstruct(D, lb, C)


parm.patterns = mat2cell(D, size(D,1), ones(1, size(D,2)));
parm.labels   = num2cell(lb(:)');

parm.lossFn = @lossCB ;
parm.constraintFn  = @constraintCB ;
parm.featureFn = @featureCB ;

parm.d = size(D, 1);
parm.nClass = max(lb);
if (min(lb) < 1)
    error('class label must be a positive integer');
end;

parm.classW = ones(parm.nClass, 1);
if strcmpi(option, 'balance')
    n = length(lb);
    aven = n/parm.nClass;
    for i=1:parm.nClass
        parm.classW(i) = aven/sum(lb == i);
    end;
end;

parm.dimension = parm.nClass*parm.d;
parm.verbose = 1;
model = svm_struct_learn(sprintf(' -c %g -o 1 -v 1 ', C), parm) ;
Ws = reshape(model.w, parm.d, parm.nClass) ;


end

% ------------------------------------------------------------------
%                                               SVM struct callbacks
% ------------------------------------------------------------------

function delta = lossCB(param, y, ybar)
% We use the slack variable rescaling. This allows us to weight different class differently.
    delta = param.classW(y)*double(y ~= ybar) ;
end

function psi = featureCB(param, x, y)
    psi = zeros(param.d*param.nClass, 1);
    psi(1+(y-1)*param.d:y*param.d) = x; 
    psi = sparse(psi) ;
end

function yhat = constraintCB(param, model, x, y)
    % slack resaling: argmax_y delta(yi, y) (1 + <psi(x,y), w> - <psi(x,yi), w>)
    % margin rescaling: argmax_y delta(yi, y) + <psi(x,y), w>    
    % Both slack rescaling and margin rescaling are the same
    Ws = reshape(model.w, param.d, param.nClass);    
    svmscores = x'*Ws;
    svmscores(y) = svmscores(y) - 1; % this is equivalent to svmscore + loss    
    [~, yhat] = max(svmscores, [], 2);
end
