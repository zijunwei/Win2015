max_o=0.7205;

% B=(trK_up>max_o );
% id=diag(ones(size(B,1),1));
% B(id==1)=0;
% [row,col]=find(B);
% rowu=unique(row);
% colu=unique(col);
% 
% if length(rowu)>length(colu)
%     tod=colu;
% else
%     tod=rowu;
%     
% end
% 
% trK(tod,:)=[];
% trK(:,tod)=[];
[row,col]=find(trK_n_abs_up>max_o);