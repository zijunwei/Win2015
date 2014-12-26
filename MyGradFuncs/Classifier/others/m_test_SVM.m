function m_test_SVM()

D1 = [0 0; 0 1; 1 0.75; 2 0.5; -1 -1]';
l1 = [1; 1; 0; 3; 2];

model = svmtrain(l1, D1', '-t 0 -c 1'); 
keyboard;