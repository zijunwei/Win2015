function z = m_rbfPreimg_minh4(D, K, sigma, lambdas, options)
%This function computes the pre-image using the line-lifting method.
%Instead of computing the pre-image of a point y1 in the feature space
%directly, this method computes the pre-image for every point joining a
%initial point y0 that we know the exact preimage and the point y1. 
%Suppose we have to find z in R^d: F(z) = y1.
%We find a mapping P: R -> R^d s/t: F(P(t)) = (1-t)*y0 + t*y1.
%Take the derivative we get: F'(P(t))*P'(t) = y1 - y0.
%This ordinary differential equation is solved using a standard Matlab ODE 
%solver.
%However, this method does not work well because:
%  1. The mass matrix F'(P(t)) is usually singular.
%  2. This type of ODE equation usually do not have solution. That makes
%  the ODE equation ill-form.
%  3. Even if the mass matrix is not singular, the function that we get out
%  of it is usually constant. In other words: P(1) ~ P(0). This means that
%  the ODE solver doesn't do much.
%  4. There are some ODE solvers such as ode23t and ode15s but they usually
%  give some errors.
%Reference: "Non-linear mappings that are globally equivalent to a
%projection" by Roy Plastock.
% By Minh Hoai Nguyen
% Last modified: 27 April 07

    % For some reasons, the ODE solves do not allow m is different from k.
    k = 15; % # of free variables, z = alpha_1*x_1 + ... + alpha_k*x_k
    m = 15; % # of reference points x_1,..., x_m
    
    KxD = K*lambdas; %<Pphi(x), phi(x_i)>
    [KxD, idxes] = sort(KxD, 'descend');
    D = D(:,idxes);
    
    z0 = options.z0;
    alphas0 = pinv(D(:,1:k)'*D(:,1:k))*(D(:,1:k)'*z0);
    z0 = D(:,1:k)*alphas0;
    
%     % Random starting point.
%     alphas0 = rand(k,1);
%     alphas0 = alphas0/sum(alphas0);
%     z0 = D(:,1:k)*alphas0;
    
    y0 = exp(sigma*m_sqrDist(D(:,1:m), z0));
    y1 = KxD(1:m);    
    odeOptions = odeset('Mass', @(t, y) dF(D, sigma, m, k, y));    
    [T,Y] = ode45(@(t, y) y1 - y0,[0, 1] ,alphas0, odeOptions);
    z = D(:,1:k)*Y(end,:)';
    
    
%Compute the mass matrix for the ODE solver.
%This is the helper function of rbfPreimg_minh4.
function M = dF(D, sigma, m, k, alphas)
    x= D(:,1:k)*alphas;
    KxD = exp(sigma*m_sqrDist(D(:,1:m),x));
    xD = x'*D(:,1:k);
    DtD = D(:,1:m)'*D(:,1:k);
    M = 2*(repmat(xD, m, 1) - DtD).*repmat(KxD,1, k);
