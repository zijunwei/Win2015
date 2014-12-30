TaskIDStr = getenv('SGE_TASK_ID');
if ~isempty(TaskIDStr)
    taskID = str2double(TaskIDStr);
else
    error('No task ID specified');
end
 
TaskStepStr = getenv('SGE_TASK_STEPSIZE');
if ~isempty(TaskStepStr)
    taskStep = str2double(TaskStepStr);
else
    error('No task step specified');
end

% qsub -t 1-20:4 ~/matlab.sh m_qsub2
nTask  = 20;
idxs = taskID:min(taskID + taskStep - 1, nTask);

% Suppose your function also takes input arguments: idxs
testxmlread(idxs);