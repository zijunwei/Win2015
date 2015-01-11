%no use at all

for i=1:1:length(pos_lb)

    filepattern=refinfo.fname{pos_lb(i)};
    ind=strfind(allnames,filepattern);
    index  = find(~cellfun(@isempty,ind));
    if length(index)>1
       disp(i); 
    end
     
%   tmp_structs=find(fv_struct.filename==filepattern);
   
end

