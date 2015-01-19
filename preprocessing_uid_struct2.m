function output=preprocessing_uid_struct2(fv_info)
% only keeps the single threads!
n=length(fv_info);
output=cell(n,1);
for i=1:1:n
   for j=1:1:length(fv_info(i).fv)
       if size(fv_info(i).fv{j},2)==1
      output{i}=[output{i},fv_info(i).fv{j}]; 
       end
   end
end


end