function m_testEnergyMin_alphaExp()
    test3();

function test1()
    nLabels = 2;
    initLabel = [2 1 2 1 2 1]';
    unaryE = [[1 2 1 1 1 1]', [1 1 1 1 2.5 1]'];

    edges = [1 4; 1 2; 2 3; 2 5; 3 6; 6 5; 5 4];
    nEdges = size(edges,1);
    pairwiseE = zeros(nEdges, nLabels, nLabels);

    pairwiseE(:,1,2) = 1;
    pairwiseE(:,2,1) = 1;

    [newLabel, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2);
    
function test2()
    initLabel = [1 2 2]';
    unaryE = [2 2; 2 2; 2.5 2.5];
    edges = [1 2; 2 3];
    pairwiseE = zeros(2, 2, 2);
    
    pairwiseE(:, 1, 2) = 1;
    pairwiseE(:, 2, 1) = 1;
    

    [newLabel, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2);
    fprintf('Done\n');

function test3()
    initLabel = [1 2 2]';
    unaryE = [10 2; 10 2; 10 2];
    edges = [1 2; 2 3; 1 3];
    pairwiseE = zeros(3, 2, 2);
    
    for i=1:3
        pairwiseE(i, :, :) = 1;
    end;
    pairwiseE(:,1,1) = 0;
    pairwiseE(:,2,2) = 0;
    
    [newLabel, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges,1);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 

    fprintf('Done\n');
    
function test4()
    initLabel = [1 2 1 2]';
    unaryE = [3 2; 3 2; 9 2; 4 2];
    edges = [1 2; 2 3; 3 4; 4 1];
    pairwiseE = zeros(4, 2, 2);
    
    for i=1:4
        pairwiseE(i, :, :) = 1;
    end;
    pairwiseE(:,1,1) = 0;
    pairwiseE(:,2,2) = 0;
    
    [newLabel, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 
    fprintf('Done\n');
    
function test5()
    initLabel = [1 2]';
    unaryE = [[2 2.5]', [2 2]'];
    edges = [1 2];
    pairwiseE = zeros(1, 2, 2);
    
    pairwiseE(:, 1, 2) = 1;
    pairwiseE(:, 2, 1) = 1;
    
    [newLabel, energy] = ml_energyMin_alphaExp(initLabel, unaryE, pairwiseE, edges);
    energy2 = ml_cmpEnergy(newLabel, unaryE, pairwiseE, edges);
    fprintf('max-flow: %g, energy: %g\n', energy, energy2); 
    fprintf('Done\n');
