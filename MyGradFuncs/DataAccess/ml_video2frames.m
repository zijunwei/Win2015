function [imH, imW, outFiles] = ml_video2frames(videoFile, sampleRate, outDir, format)
% function ml_video2frames(videoFile, sampleRate, outDir)
% Read a video file and extract frames and dump them into a directory. 
% Inputs:
%   videoFile: path to the video 
%   sampleRate: sampling rate (a positive integer)
%   outDir: directory to dump image files
% Outputs:
%   save .bmp files in the outDir
%   imH, imW: height, width and # of extracted frames
%   outFiles: list of output files
% By Minh Hoai Nguyen (minhhoai@cmu.edu)
% Date: 20 July 09

mov = mmreader(videoFile);
vidFrames = read(mov);
nFrame = 0;
outFiles = cell(1,0);
for i=1:sampleRate:mov.NumberOfFrames
    fprintf('Writing frame %d\n', i);
    nFrame = nFrame + 1;
    frame = vidFrames(:,:,:,i);
    outFiles{nFrame} = sprintf('%s/frame_%04d.%s',outDir, i, format);
    imwrite(frame, outFiles{nFrame}, format);
end;
imH = mov.Height;
imW = mov.Width;
