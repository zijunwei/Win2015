classdef videoOperations
    % Modified from Minh's code
    % functions:
    %
    properties (Constant)
        ffmpegBin='/usr/local/bin/ffmpeg';
        
        
    end;
    
    
    methods (Static)
        
        % do extractions with video specifications
        function extractFVWhole_sp(input_file,save_file)
            
            %clip.flip = 1; % flip horizontally
            %opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            opts.fps = 10;
            opts.newH = 360;
            %opts.frmQuality = '-q:v 4';
            %opts.frmExt = 'jpg';
            %ML_VidClip.extFrms(clip2, outFrmDir2, opts);
            clip.file = input_file;
            
            outFrmDir =[ 'frames',ml_randStr()];
            opts.ffmpegBin = videoOperations.ffmpegBin;
            
            % first extract frames
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
            imFiles = ml_getFilesInDir(outFrmDir, 'png');
            
            
            nFrm = length(imFiles);
            gmmModelFile = 'GMM.mat'; % the GMM model file for Fisher Vector encoding
            % Replace it with your own model file if necessary
            
            
            frmIdx=1:1:nFrm;
            fv = ML_IDTD.fvEncode4dir(outFrmDir, 'png', frmIdx, gmmModelFile);
            save(save_file,'fv');
            % demo 4 is not complete running svm
            cmd = sprintf('rm -rf %s', outFrmDir);
            fprintf('%s\n', cmd);
            %             system(cmd);
        end;
        
        
        function extractFVWhole(input_file,save_file)
            clip.file = input_file;
            
            outFrmDir =[ 'frames',ml_randStr()];
            opts.ffmpegBin = videoOperations.ffmpegBin;
            
            % first extract frames
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
            imFiles = ml_getFilesInDir(outFrmDir, 'png');
            
            
            nFrm = length(imFiles);
            gmmModelFile = 'GMM.mat'; % the GMM model file for Fisher Vector encoding
            % Replace it with your own model file if necessary
            
            
            frmIdx=1:1:nFrm;
            fv = ML_IDTD.fvEncode4dir(outFrmDir, 'png', frmIdx, gmmModelFile);
            save(save_file,'fv');
            % demo 4 is not complete running svm
            cmd = sprintf('rm -rf %s', outFrmDir);
            fprintf('%s\n', cmd);
           % system(cmd);
            
        end;
        
        
        function extractFrms(input_file,outFrmDir)
            clip.file=input_file;
            opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
        end;
        % directly calculate fv from the txt file
        function fvEncoder4File(input_file,gmmfile)
            
            
        end;
        % Extracting a video for a specific part of a longer video
        function demo1()
            clip.file = 'ori.mp4';
            clip.start ='00:01:00,000';
            clip.end = '00:01:30,269';
            opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            opts.newH = 480;
            ML_VidClip.extVid(clip, 'out.mp4', opts);
        end;
        
        % Extracting frames
        function demo2()
            % Example 1, extracting a clip
            clip.file = 'sample.mp4';
            outFrmDir = 'frames';
            opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
            % Example 2, with various options
            outFrmDir2 = 'frames2';
            clip2.file = 'sample.mp4';
            clip2.start = '00:00:02,000'; % specific section of the clip
            clip2.end = '00:00:05,250';
            clip2.flip = 1; % flip horizontally
            opts2.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            opts2.fps = 10;
            opts2.newH = 200;
            opts2.frmQuality = '-q:v 4';
            opts2.frmExt = 'jpg';
            ML_VidClip.extFrms(clip2, outFrmDir2, opts2);
        end;
        
        % Display shots and threads for a video clip
        function demo3()
            clip.file = 'sample.mp4';
            outFrmDir = 'frames';
            opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            
            % first extract frames
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
            imFiles = ml_getFilesInDir(outFrmDir, 'png');
            maxDist = 5;
            featType = 'sift';
            shldDisp = 1;
            
            [shotBnds, threads] = ML_VidThread.getThreads(imFiles, maxDist, featType, shldDisp);
            
            % Suppose there is an event from frames 250 to 550
            eventStart = 250;
            eventEnd = 550;
            ML_VidThread.dispThreads(length(imFiles), shotBnds, threads, eventStart, eventEnd);
            
            outHtmlDir = './gifs/';
            ML_VidThread.createHtmls(imFiles, shotBnds, threads, outHtmlDir);
            fprintf('Use an Internet browser to open %s/shots.html to display shots\n', outHtmlDir);
            fprintf('Use an Internet browser to open %s/threads.html to display threads\n', outHtmlDir);
        end;
        
        % Compute Fisher vector encoding for dense trajectory features
        function demo4()
            clip.file = 'sample.mp4';
            outFrmDir = 'frames';
            %opts.ffmpegBin = '/opt/local/bin/ffmpeg';
            opts.ffmpegBin = M_TestVidFuncs.ffmpegBin;
            
            % first extract frames
            ML_VidClip.extFrms(clip, outFrmDir, opts);
            
            imFiles = ml_getFilesInDir(outFrmDir, 'png');
            maxDist = 5;
            featType = 'sift';
            shldDisp = 1;
            
            [shotBnds, threads] = ML_VidThread.getThreads(imFiles, maxDist, featType, shldDisp);
            nFrm = length(imFiles);
            nShot = length(shotBnds) + 1;
            
            shots = zeros(2, nShot);
            shots(1,1) = 1;
            shots(2, end) = nFrm;
            
            if ~isempty(shotBnds)
                shots(1, 2:end)   = shotBnds;
                shots(2, 1:end-1) = shotBnds-1;
            end
            
            
            % Let get a Fisher Vector encoding for Thread 3
            % First, extract all frames from Thread 3 and put the indexes in order
            frmIdxss = cell(1, length(threads{3}));
            for i=1:length(threads{3});
                shotId = threads{3}(i);
                frmIdxss{i} = shots(1,shotId):shots(2,shotId);
            end
            frmIdxs = cat(2, frmIdxss{:}); % indexes of frames in Thread 3
            
            gmmModelFile = 'GMM.mat'; % the GMM model file for Fisher Vector encoding
            % Replace it with your own model file if necessary
            
            % Get the Fisher Vector feature
            fv = ML_IDTD.fvEncode4dir(outFrmDir, 'png', frmIdxs, gmmModelFile);
            % demo 4 is not complete running svm
            
            
        end;
        
        
    end
    
end

