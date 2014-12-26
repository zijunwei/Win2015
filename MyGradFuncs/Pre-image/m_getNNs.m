function NNs = m_getNNs(D, K, lambdas, nNNs)
%Get nearest neighbours of the vector in feature space.

    KxD = K*lambdas; % Pphi(x)'*phi(x_i) for all i.    
    [sorted, idxes] = sort(KxD, 'descend');   
    idxes = idxes(1:nNNs);
    NNs = D(:, idxes);