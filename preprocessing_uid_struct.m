function output=preprocessing_uid_struct(fv_info)
n=length(fv_info);
output=cell(n,1);
for i=1:1:n
   for j=1:1:length(fv_info(i).fv)
      output{i}=[output{i},mean(fv_info(i).fv{j},2)]; 
   end
end


end