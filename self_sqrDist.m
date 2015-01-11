function [ SqrDist ] = self_sqrDist( Data )
%SELF_SQRDIST this funciton adopts from minh's ml_sqrDist function. it
%calculates the row vector's inner distance but saves a lot of time than
%using ml_sqrDist(self,self)
% tested correct!
Data=Data';
n = size(Data,2);
x = sum(Data.^2,1)';
xp=x';
SqrDist = x(:,ones(1, n)) + xp(ones(n,1),:) - 2*(Data'*Data);


end

