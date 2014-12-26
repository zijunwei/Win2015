function M=check_read_data(data_path,data_length)
% read matrix of (Improved_dense_Trajectories) from txt files 
% input:
%   data_path: the full path to the txt file
%   data_length: 
if nargin<2
data_length=466;
end
f_id=fopen(data_path);
counter=0;
A={};
while 1
 line_data=fgetl(f_id);
 
 if ~ischar(line_data)
     break;
 end

  temp=sscanf(line_data,'%f');
  if length(temp)==data_length
      counter=counter+1;
      A{counter}=temp;
  end  
 end
 fclose(f_id);
 M=cell2mat(A);
end