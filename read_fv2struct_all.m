%this file loads fv threads to structs
% fv.name  : the name of the file
% fv.vec   : the fisher vector saved in the file
% in some cases the files that doesn't extract any dense trajectories are
% automatically deleted.
% for fv_thread, including all the empty files, there is a total of 7292
% files, if the empty files are deleted, there is a total of 6078
% ****the next step might be to find a way to avoid empty files better than ****

function fv_struct=read_fv2struct_all(file_dir_string)
fv_struct = struct('name',{},'fv',{},'size',{});
% file_dir_string='/Users/zijunwei/Dev/Win2015/DataFromServer/fv_thread'; % 6078 files

fv_files=dir(fullfile(file_dir_string,'*.mat'));

for i=1:1:length(fv_files)
    fv_struct(i).name=fv_files(i).name;
    fv_struct(i).size=fv_files(i).bytes;
    fv_struct(i).fv=form_fv( fullfile(file_dir_string,fv_struct(i).name));
    
    
end
end