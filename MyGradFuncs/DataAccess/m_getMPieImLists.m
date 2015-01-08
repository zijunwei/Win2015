function imList = m_getMPieImLists(osType, ...
        cameraNos, sessionNos, recordNos, lightNos, subjectIDs)
% imList = m_getImLmLists(osType, ...
%       cameraNos, sessionNos, recordNos, lightNos, subjectIDs)    
% imList = m_getImLmLists(osType, ...
%       cameraNos, sessionNos, recordNos, lightNos)    
% Get a list of image files and landmark files that exist and have the
% settings match with the params specified.
% Inputs:
%   osType: type of operating system, either 'linux' or 'win'
%   cameraNos: the IDs of cameras that we should retrieve images. 
%   sessionNos: there are 4 sessions 1,2,3,4.
%   recordNos: recording number in each session, images taken in same
%       session with same recording number are of same facial expression.
%   lightNos: illumination of images required.
%   subjectIDs: the IDs of people we should retrieve images. If this is not
%       set, the defaul will be 1:337.
% Outputs:
%   imList: cell array of image names.
% Examples:
%   imList = m_getMPieImLists('win', 51, 1:4, 1, 5)
%   imList2 = m_getMPieImLists('win', 51, 4, 2, 5)
%   This gives you images of frontal, neutral, front light of all people.
% By Minh Hoai Nguyen
% Date: 10 April 07

    
if strcmp(osType, 'linux')
    imDir = '/cv/data/face/multipi';
else
    imDir = 'Z:\DataBases\multipie\images\';
end;
if ~exist('subjectIDs', 'var')
    % The document records total of 337 subjects, 
    % however, I saw some subjects with ID 446.
    subjectIDs = 1:337; 
end;        

count = 0;
for cameraNo=cameraNos
    str = num2str(cameraNo);
    cameraDir = sprintf('%.2d_%s', str2num(str(1:end-1)), str(end));
    for ss=sessionNos %session
        for recordNo=recordNos
            for lightNo=lightNos
                for id=subjectIDs %person id
                    name = sprintf('%.3d_%.2d_%.2d_%.3d_%.2d', ...
                        id, ss, recordNo, cameraNo, lightNo);
                    imPath = sprintf('%s\\session%.2d\\multipie_png\\%.3d\\%.2d\\%s\\', ...
                        imDir, ss,id, recordNo, cameraDir);
                    imName = [imPath, name, '.png'];
                    fprintf('%s\n', imName);
                    if exist(imName, 'file')
                        count = count + 1;
                        imList{count,1} = imName;
                    end;
                end;
            end;
        end;
    end;
end;
