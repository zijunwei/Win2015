% this file is used to read the 3 annotations files from google sheet
% 3 annotaiton files:
%  AnswerPhone+DriveCar+Eat+Fight - Sheet1.csv
%  GetOutCar+HandShake+HugPerson+Kiss - Sheet1.csv
%  Run+SitDown+SitUp+StandUp - Sheet1.csv
clear;
csv_file='AnswerPhone+DriveCar+Eat+Fight - Sheet1.csv';
file_cell=read_mixed_csv(csv_file,',');

file_names=file_cell(:,1);


Anno=[];

% read AnswerPhone+DriveCar+Eat+Fight
for i=2:1:5
m1=file_cell(:,i);
m1=cell2mat(m1);
m1=str2num(m1);
Anno=[Anno,m1];
end


% read GetOutCar+HandShake+HugPerson+Kiss
csv_file='GetOutCar+HandShake+HugPerson+Kiss - Sheet1.csv';
file_cell=read_mixed_csv(csv_file,',');
for i=2:1:5
m1=file_cell(:,i);
m1=cell2mat(m1);
m1=str2num(m1);
Anno=[Anno,m1];
end

% read Run+SitDown+SitUp+StandUp - Sheet1.csv
csv_file='Run+SitDown+SitUp+StandUp - Sheet1.csv';
file_cell=read_mixed_csv(csv_file,',');
for i=2:1:5
m1=file_cell(:,i);
m1=cell2mat(m1);
m1=str2num(m1);
Anno=[Anno,m1];
end




% filter out the bad names:
file_stems=cellfun(@(v)v(1:end-5),file_names,'uniformoutput',false);

