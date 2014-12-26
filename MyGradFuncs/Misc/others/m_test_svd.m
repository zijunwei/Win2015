function m_test_svd()
    X = rand(5,4)
    [U,S,V] = svd(X, 'econ')
    [U2,S2, V2] = ml_svd(X, 0.6)
    keyboard;