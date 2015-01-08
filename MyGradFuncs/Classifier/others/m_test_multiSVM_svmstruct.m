randn('state',0) ;
rand('state',0) ;

% ------------------------------------------------------------------
%                                                      Generate data
% ------------------------------------------------------------------


nClass = 3;
n = 100;
D = zeros(2, n);
lb = zeros(n,1);
for i=1:100
    D(:,i) = diag([2 .5]) * randn(2, 1) ;
    lb(i)  = randi(nClass);     
    D(:,i) = D(:,i) + 4;
%     D(2,i) = D(2,i) + 3; % 2*(lb(i)-1.5); 
end

for i=1:nClass
    th = 2*pi*i/nClass ;
    c = cos(th) ;
    s = sin(th) ;
    D(:,lb==i) = [c -s ; s c] * D(:,lb == i);
end


C = 1;

Ws = ml_multiSVM_svmstruct(D, lb, C, 'balance');


% ------------------------------------------------------------------
%                                                              Plots
% ------------------------------------------------------------------

figure(1) ; clf ; hold on ;
x = D ;
y = lb;
colors = {'g.', 'r.', 'k.'};
lcolors = {'g', 'r', 'k'};
for i=1:nClass    
    plot(x(1, y==i), x(2, y==i), colors{i});
    set(line([0 5*Ws(1,i)], [0 5*Ws(2,i)]), 'color', lcolors{i}, 'linewidth', 4) ;    
end;

% xlim([-3 3]) ;
% ylim([-3 3]) ;
axis equal ;
set(gca, 'color', 'b') ;

