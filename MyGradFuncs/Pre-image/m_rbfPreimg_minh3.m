function z = m_rbfPreimg_minh3(D, K, sigma, lambdas)
% This function find the pre-image by optimize a quadratic function.
% The quadratic function is to minimize the error of
% sum((<z,x_i>-desirableDotProd)^2). It also add some constraints to
% preserve the ranking of similarity measurement of z and and training
% data. In other words, we want z such that k(z,x_i) <= k(z, x_j) if
% <Pphi(x), phi(x_i)> <= <Pphi(x), phi(x_j)>
%
% This approach turms out to be inferior to Kwok's method. The reason is
% Kwok method usually use 10 or 20 nearest neighbours. Since the number of
% free variables in Kwok's method is the same with the number of pixels
% which is much more than the number of equation. Therefore, Kwok's method
% always returns a exact solution upto a constant offset because of the
% estimate of z^2 is not very accurate. However, because each k(z,x_i) is
% different from its target by the same offset, the ranking is preserved. 
%
% If the no of ranking constraints, m, is high, this method takes forever.
% By Minh Hoai Nguyen
% Last modified: 27 Apr 07
    
    n = 30; % # of terms in objective function.
    m = 100; % # of terms in constraints.
    k = 10; % # of free variables, z = alpha_1*x_1 + ... + alpha_k*x_k
    q = 0; % # of reference point to compute z2.

    KxD = K*lambdas; %<Pphi(x), phi(x_i)>
    [KxD, idxes] = sort(KxD, 'descend');
    D = D(:,idxes);
    lambdas = lambdas(idxes);


    desSqrDist = 1/sigma*log(KxD); %desired sqr dist from z to x_i, i=1,...,n

    if q == 0
        shiftVec = zeros(size(D(:,1)));
    else
        shiftVec = mean(D(:,1:q),2);
    end;

    D = D - repmat(shiftVec, 1, size(D,2));
    X2 = sum(D.*D,1)'; %Sqr length of x_i    
    if q == 0
        z2 = 1/sigma*log(exp(sigma*X2)'*lambdas);
    else
        z2 = mean(desSqrDist(1:q) - X2(1:q));
    end;

    aux = (X2 + z2 - desSqrDist)/2; %because aux(i) = (z^2 + x_i^2 - d_i^2)/2;

%     z = minh3Helper1(D, n, m, k, aux, X2);
    z = minh3Helper2(D, n, m, aux, X2);
    z = z + shiftVec;

    
% This is a helper function for Minh3 method.
% This assumes that z is a linear combination of some traing examples.
% In other words: z = D*alphas. This function setup a quadratic
% optimization problem for alphas and compute z from alphas.
function z = minh3Helper1(D, n, m, k, aux, X2)
    A = D(:,2:m) - D(:,1:m-1); 
    A = 2*A'*D(:,1:k);
    A(:,1+k:k+m-1) = -eye(m-1);
    A(m:2*m-2,1+k:k+m-1) = -eye(m-1);
    b = X2(2:m) - X2(1:m-1);
    b(m:2*m-2) = 0;
    DtD = D(:,1:n)'*D(:,1:k);
    H = DtD'*DtD;
    H(1+k:k+m-1,1+k:k+m-1) = 0;
    f = -DtD'*aux(1:n);    
    cost = 100;
    f(1+k:k+m-1) = cost;
    Aeq = [ones(1,k), zeros(1,m-1)];
    beq = 1;

    %Default MaxIter is 200;
    opts = optimset('LargeScale', 'off', 'Display', 'iter', 'MaxIter', 500);
    sol = quadprog(H, f, A, b, Aeq, beq, [], [],[], opts);
    z = D(:,1:k)*sol(1:k);

% Unlike the minh3Helper1 function. This does not assume z is combination
% of training data. This function sets up a quadratic otimization problem
% in z and solve for z directly.
function z = minh3Helper2(D, n, m, aux, X2)    
    d = size(D,1);    
    A = D(:,2:m) - D(:,1:m-1); 
    A = 2*A';
    A(:,1+d:d+m-1) = -eye(m-1);
    b = X2(2:m) - X2(1:m-1);
    H = D(:,1:n)*D(:,1:n)';
    H(1+d:d+m-1,1+d:d+m-1) = 0;
    f = -D(:,1:n)*aux(1:n);
    cost = 1000;
    f(1+d:d+m-1) = cost;
    
    %Default MaxIter is 200;
    opts = optimset('LargeScale', 'off', 'Display', 'iter', 'MaxIter', 1000);
    lb = zeros(size(f));
    ub = ones(size(f));
    ub(1+d:end) = 5;
    sol = quadprog(H, f, A, b, [], [], lb, ub,[], opts);
    z = sol(1:size(D,1));