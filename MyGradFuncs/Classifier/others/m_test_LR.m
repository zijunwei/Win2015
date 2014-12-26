function m_test_LR()
% Test two functions: ml_LR_gradient and ml_LR_IRLS
    d = 5;
    n = 20000;
    D = randn(d, n);
    w = 2*randn(d,1);
    w0 = 2;
    label = 1./(1+exp(-w0 - D'*w)) > rand(n,1); % mimic the probability assumption used in LR.
    
    tic;
    [estW0, estW] = ml_LR_gradient(D, label, 1000, 0.001);
    toc;
    tic;
    [estW0_b, estW_b] = ml_LR_IRLS(D, label);
    toc;

    disp([w0, w']);
    disp([estW0, estW']);
    disp([estW0_b, estW_b']);
    