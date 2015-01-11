
% Conclusion from Jan 10 2015.
% NO matter how large(0.75) the threshold set, it always return
thres_coef=0.5; % any distance that is smaller than 10 times the minimal distance will be considered as "singular"
i=1;
load(sprintf('%s_arg_neg_l2.mat',classTxt{i}));

% only deal with negpart
trD_p=trD(trLb== 1,:);
trD_n=trD(trLb==-1,:);

% remove singularity in trD_n;
inner_dist=self_sqrDist(trD_n);
tri_inner_dist=triu(inner_dist,1);


thres=min_dist_o;




%[minitems,toD]=min(tri_inner_dist,[],2);
tri_inner_dist_fill=tri_inner_dist;
tri_inner_dist_fill(tri_inner_dist_fill==0)=100;
[rows,cols]=find(tri_inner_dist_fill<thres);
rowsd=unique(rows);
colsd=unique(cols);

% toD(minitems>thres)=0;
% 
% toD_nz=toD(toD~=0);
% toD_nz=unique(toD_nz);
% trD_n(toD_nz,:)=[];
% 
% trLb=[ones(size(trD_p,1),1);-1*ones(size(trD_n,1),1)];
% trD=[trD_n;trD_p];


% rubbish:
%toD_nz=toD(toD~=0);
%toD(toD_nz)=0;
% for j=1:1:length(toD)
%       if toD(i)~=0
%          toD(toD(i))=0; 
%       end
%     
% end