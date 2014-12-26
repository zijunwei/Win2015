function err = m_cmpErr(D, K, sigma, lambdas, z)
    KzD = exp(sigma*ml_sqrDist(D,z));
    err = 1 + lambdas'*K*lambdas - 2*lambdas'*KzD;
