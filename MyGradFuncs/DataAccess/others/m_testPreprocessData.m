function m_testPreprocessData()
% Contain an example of how to use m_preprocessData
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 29 Jan 07


% Generate toy data
samples=18; noisex=0; noisey=0;
x= 2*cos(2*(0:pi/samples:pi)); 
x= x + noisex*randn(1, length(x)) + 5;
x(end) = [];
y= sin(2*(0:pi/samples:pi)); 
y= y + noisey*randn(1, length(y)) + 20;
y(end) = [];

Data = [x; y];
subplot 221; scatter(Data(1,:), Data(2,:)); axis equal; 
Data = m_preprocessData(Data, 1, 0, 0);
subplot 222; scatter(Data(1,:), Data(2,:)); axis equal; 
Data = m_preprocessData(Data, 0, 1, 0);
subplot 223; scatter(Data(1,:), Data(2,:)); axis equal; 
Data = [x; y];
Data = m_preprocessData(Data, 0, 1, 1);
subplot 224; scatter(Data(1,:), Data(2,:)); axis equal; 