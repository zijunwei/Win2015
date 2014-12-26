# Backup script
# By: Minh Hoai Nguyen (minhhoai@gmail.com)

# The only two parameters to set
backupName='titan_data'
srcDir='/mnt/titan_data/subtitle_proc'
destDir='/media/MD_Seagate2/Backup/'$backupName'/'

dateStr=$(date +"%Y_%m_%d")
logFile=$HOME'/backupLogs/'$backupName'_'$dateStr'.log'
errFile=$HOME'/backupLogs/'$backupName'_'$dateStr'.err'

command='mkdir -p '$destDir
echo $command
eval $command

command='rsync -r -t -v --progress -u -s '$srcDir' '$destDir' > '$logFile' 2> '$errFile
echo $command
eval $command

command='mkdir -p '$destDir'/backupLogs'
echo $command
eval $command

command='cp '$logFile' '$destDir'backupLogs/'
echo $command
eval $command
command='cp '$errFile' '$destDir'backupLogs/'
echo $command
eval $command
