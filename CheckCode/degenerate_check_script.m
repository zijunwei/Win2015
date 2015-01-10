% step 1: check degeneration of normal matrix
% load('hollywood2_fv_thread_l2.mat');
%trK=trD*trD';
%[isCond,val]=Zj_MatrixChecking.iscondition(trK);

%step2 check degenration of negative-augmented matrix
% trKA=trDN*trDN';
% [isCondA,valA]=Zj_MatrixChecking.iscondition(trKA);

% step 3: check degeneration of positive examples
% trP=trDN(1:66,:);
% trKP=trP*trP';
% [isCondP,valP]=Zj_MatrixChecking.iscondition(trKP);

% step 4: check the degeneration of argumented negative examples
%  trN=trDN(67:end,:);
%  trKN=trN*trN';
%  [isCondN,valN]=Zj_MatrixChecking.iscondition(trKN);
