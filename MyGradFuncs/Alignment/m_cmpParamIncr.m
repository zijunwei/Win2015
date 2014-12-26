function a = m_cmpParamIncr(D, d2, Alphas, betas, kOpts, curI, Ja)
% function a = m_cmpParamIncr(D, Alphas, betas, kOpts, curI, Ja)
% This function computes the necessary increment of parameters. This
% function will call either m_cmpParamIncr4Poly or m_cmpParamIncr4RBF
% depending on the type of kernel set in kOpts.
% 
% Inputs:
%   D: data, each column is a data instance.
%   Alphas, betas: model parameters returned by function: ml_kpcaProjCoeffs
%   kOpts: the options for the kernel function.
%   curI: pixel values at current estimated location. curI = I(f(X,0))
%   Ja: Jacobiban, d(I(X,a))/d(a) estimated at a = 0;
% Output:
%   a: the greedy increment of parameters.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 12 June 07

    if sumsqr(isnan(Ja))
        fprintf(2, 'm_cmpParamIncr: some entries of Ja are NAN\n');
        a = 0;
    else
        if strcmp(kOpts.kernelType, 'exp')
            a = cmpParamIncr4RBF(D, d2, Alphas, betas, kOpts.gamma, curI, Ja);
        elseif strcmp(kOpts.kernelType, 'poly')
            a = cmpParamIncr4Poly(D, Alphas, betas, kOpts.gamma, ...
                kOpts.deg, curI, Ja);
        end;
    end;

function a = cmpParamIncr4Poly(D, Alphas, betas, gamma, m, curI, Ja)
% function a = m_cmpIncrParam4Poly(D, Alphas, betas, gamma, curI, Ja)
% This function computes the necessary increment of parameters. This
% function works for Polynomial kernel of the form: (<x,y> + gamma)^m;
% 
% Inputs:
%   D: data, each column is a data instance.
%   Alphas, betas: model parameters returned by function: ml_kpcaProjCoeffs
%   gamma, m: the polynomial kernel parameter: (<x,y> + gamma)^m;
%   curI: pixel values at current estimated location. curI = I(f(X,0))
%   Ja: Jacobiban, d(I(X,a))/d(a) estimated at a = 0;
% Output:
%   a: the greedy increment of parameters.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 19 May 07

    Alphas = 0.5*(Alphas + Alphas');

    n = size(D, 2);
    eta = (curI'*curI + gamma)^(m-1);
    etas = (D'*curI + gamma).^(m-1);
    H = repmat(etas, 1, n).*repmat(etas',n,1).*Alphas;
    sH = sum(H,2);
    B = -D*(2*gamma*sH + betas.*etas);

    JatA = 2*(Ja'*D)*H*D' + 2*eta*Ja';
    JatAJa = JatA*Ja;
    JatB = Ja'*B;

    a = -inv(JatAJa)*(JatA*curI + JatB);
    
    
    
    
function a = cmpParamIncr4RBF(D, d2, Alphas, betas, gamma, curI, Ja)
% function a = m_cmpIncrParam4RBF(D, Alphas, betas, gamma, curI, Ja)
% This function computes the necessary increment of parameters. This
% function is for Radial Basis function.
% 
% Inputs:
%   D: data, each column is a data instance.
%   Alphas, betas: model parameters returned by function: ml_kpcaProjCoeffs
%   gamma: the Gaussian kernel parameter: exp(-gamma*||x -y||^2)
%   curI: pixel values at current estimated location. curI = I(f(X,0))
%   Ja: Jacobiban, d(I(X,a))/d(a) estimated at a = 0;
% Output:
%   a: the greedy increment of parameters.
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Last modified: 10 May 07


    n = size(D,2);
    dK = exp(-gamma*m_sqrDist2(D, curI, d2));
    Ps = Alphas.*repmat(dK, 1, n).*repmat(dK', n, 1);
%     Ps = Alphas.*(dK*dK'); This is probably slower than the above line.

    qs = betas.*dK;
    sP = sum(Ps,2);
    s2Pq = 2*sP + qs;
    ss2Pq = sum(s2Pq,1);
    aux = D*s2Pq/ss2Pq - curI;

    a = inv(Ja'*Ja)*(Ja'*aux);
    
    
