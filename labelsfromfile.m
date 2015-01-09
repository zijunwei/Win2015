% this function generats the file names of training as well as testing
% categories

function [trainingclipsets,testingclipsets]=labelsfromfile(input_dir)


training_pattern='*_train.txt';
testing_pattern='*_test.txt';

trainingclipsets=formcell(input_dir,training_pattern);
testingclipsets=formcell(input_dir,testing_pattern);

end
function filecell= formcell(input_dir,pattern)

files=dir(fullfile(input_dir,pattern));
filecell=cell(length(files),1);
for i=1:1:length(files)

    filecell{i}=fullfile(input_dir,files(i).name);
end
end