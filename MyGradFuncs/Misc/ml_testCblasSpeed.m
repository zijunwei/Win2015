function ml_testCblasSpeed()
% function ml_testCblasSpeed()
% Testing the speed of Cblas. Comparing it with C++ and Matlab
% By Minh Hoai Nguyen (minhhoai@gmail.com)
% Date: 3 June 2012 

% compilation for m_mexTestCblasSpeed.cpp
% mex -I/opt/local/include -L/opt/local/lib/ -lcblas -latlas m_mexTestCblasSpeed.cpp
% or: mex -L/usr/lib64/atlas/ -lcblas -latlas m_mexTestCblasSpeed.cpp

nRepeat = 10000;
wSz = 1e5;

d= 10000;
k = wSz/d;
run_test(d, k, nRepeat);


d= 1000;
k = wSz/d;
run_test(d, k, nRepeat);


d= 100;
k = wSz/d;
run_test(d, k, nRepeat);

d= 10;
k = wSz/d;
run_test(d, k, nRepeat);



function run_test(d, k, nRepeat)

W = rand(d, k);
x = rand(d,1);
b = rand(k,1);


% fprintf('not using Cblas\n');
startT = tic; 
A1 = m_mexTestCblasSpeed(W, b, x, nRepeat, 0); 
duration_C = toc(startT);
% fprintf('using Cblas\n');
startT = tic; 
A2 = m_mexTestCblasSpeed(W, b, x, nRepeat, 1); 
duration_Cblas = toc(startT);

startT = tic; 
for i=1:nRepeat
    A3 = W'*x + b;
end
duration_matlab = toc(startT);

fprintf('d: %d, k: %d, nRepeat: %d\n', d, k, nRepeat);
fprintf('  Result diff: Cblas vs. Matlab: %g, C++ vs. Matlab: %g\n', sum(abs(A1(:) - A3(:))), sum(abs(A2(:) - A3(:))));
fprintf('  Time, C++: %g, Cblas: %g, matlab: %g\n', duration_C, duration_Cblas, duration_matlab);