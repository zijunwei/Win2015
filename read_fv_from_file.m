function [ fv_vec,outsize ] = read_fv_from_file( input_file ,dim)
%FORM_FV This function reads fisher vector from file and then form a single
% row vector
if nargin<2
   dim=109056; 
end
load(input_file);
if nargout>1
    s=dir(input_file);
    outsize=s.bytes;
end

if isempty(fv)
   fv_vec=[];
   return;
end
% define the sequence trajXY, trajHog,trajHof, trajMbh
fv_vec=[fv.trajXY ;fv.trajHog ;fv.trajHof ;fv.trajMbh];
if length(fv_vec)~=dim
   warning(['Caution! ',input_file,' fv dimension inconsistent']) ;
end
fv_vec=fv_vec';

end

