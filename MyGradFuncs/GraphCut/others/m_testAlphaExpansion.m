function m_testAlphaExpansion()
    test5();

function test1()
    nLabels = 2;
    curLabel = [2 1 2 1 2 1]';
    unaryE = [[1 2 1 1 1 1]', [1 1 1 1 2.5 1]'];

    edges = [1 4; 1 2; 2 3; 2 5; 3 6; 6 5; 5 4];
    nEdges = size(edges,1);
    pairwiseE = zeros(nEdges, nLabels, nLabels);

    pairwiseE(:,1,2) = 1;
    pairwiseE(:,2,1) = 1;

    alpha = 2;

    [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    disp(newLabel');
    fprintf('max-flow: %g, energy: %g\n', energy, energy2);
    
function test2()
    curLabel = [1 2 2]';
    unaryE = [2 2; 2 2; 2.5 2.5];
    edges = [1 2; 2 3];
    pairwiseE = zeros(2, 2, 2);
    
    pairwiseE(:, 1, 2) = 1;
    pairwiseE(:, 2, 1) = 1;
    
    alpha = 1;
    [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
    disp(newLabel');
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2);
    fprintf('Done\n');

function test3()
    curLabel = [1 2 2]';
    unaryE = [10 2; 10 2; 10 2];
    edges = [1 2; 2 3; 1 3];
    pairwiseE = zeros(3, 2, 2);
    
    for i=1:3
        pairwiseE(i, :, :) = 1;
    end;
    pairwiseE(:,1,1) = 0;
    pairwiseE(:,2,2) = 0;
    
    alpha = 1;
    [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
    disp(newLabel');
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 

    fprintf('Done\n');
    
function test4()
    curLabel = [1 2 1 2]';
    unaryE = [3 2; 3 2; 9 2; 4 2];
    edges = [1 2; 2 3; 3 4; 4 1];
    pairwiseE = zeros(4, 2, 2);
    
    for i=1:4
        pairwiseE(i, :, :) = 1;
    end;
    pairwiseE(:,1,1) = 0;
    pairwiseE(:,2,2) = 0;
    
    alpha = 1;
    [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
    disp(newLabel');
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 
    fprintf('Done\n');
    
function test5()
    curLabel = [1 2]';
    unaryE = [[2 2.5]', [2 2]'];
    edges = [1 2];
    pairwiseE = zeros(1, 2, 2);
    
    pairwiseE(:, 1, 2) = 1;
    pairwiseE(:, 2, 1) = 1;
    
    alpha = 1;
    [newLabel, energy] = ml_alphaExpansion(curLabel, unaryE, pairwiseE, edges, alpha);
    disp(newLabel');
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 
    fprintf('Done\n');
