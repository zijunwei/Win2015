function ml_data2arff(Data, labels, weights, outFile)
% function ml_data2arff(Data, labels, weights, outFile)
% Write data in Attribute Relation File Format to an output file that is
% compatible with Weka software.
% Inputs:
%   Data: a d*n matrix, d: # of attrs, n: # of instances
%   labels: n*1 vector
%   weights: either empty or n*1 vector, weights for data instances
%   outFile: file to store result.
% Outputs:
%   Data in ARFF format written in outFile.
% By: Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 25 Dec 08

fid = fopen(outFile, 'w');

fprintf(fid, '@RELATION MinhData\n\n'); 

for i=1:size(Data, 1)
    fprintf(fid, '@ATTRIBUTE %d NUMERIC\n', i);
end;



ul = unique(labels); % unique labels
fprintf(fid, '@ATTRIBUTE class {');
fprintf(fid, '%d, ', ul(1:end-1));
fprintf(fid, '%d}\n\n', ul(end));

fprintf(fid, '@DATA\n');
for i=1:size(Data, 2)
    fprintf(fid, '%f,', Data(:,i));
    fprintf(fid, '%d', labels(i));
    if exist('weights', 'var') && ~isempty(weights)
        fprintf(fid, ', {%f}\n', weights(i));
    else
        fprintf(fid, '\n');
    end;
end;

