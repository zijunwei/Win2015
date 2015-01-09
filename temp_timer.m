tic;
pos_fv=zeros(length(pos_lb),fv_dim);
for i=1:1:length(pos_lb)
    pos_fv(i,:)=arg_fv(pos_lb(i)).fv{1};
end
toc;