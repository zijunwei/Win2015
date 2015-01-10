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
       
        
       
    end
    
end

