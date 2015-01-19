% experiment 2
% we use the data (psni) to test the lssvm precision

Init;

file_pattern='%s_psni_l2.mat';

load('H2_tstLb');
load('H2_tstD_l2');

lambda=1e-6;
aps=zeros(length(classTxt),1);

for i=1:1:length(classTxt)
   load(sprintf(file_pattern,classTxt{i}));
   tstLb_i=tstLb(i,:);
   aps(i)=kerLSSVM_singleCate(lambda,trD,trLb',tstD,tstLb_i);
    
end

 for i=1:length(classTxt)
        cls = classTxt{i};
        fprintf('%-11s & %.1f \\\\ \\hline\n', cls, 100*aps(i));
 end
    fprintf('%-11s & %.1f \\\\ \\hline\n', 'mean', 100*mean(aps));