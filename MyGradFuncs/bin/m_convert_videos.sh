#!/bin/bash
# Convert videos to mp4 to save space

OPTS=' -filter:v yadif -strict experimental -sameq -vcodec libx264 -acodec aac -ab 128k -ar 22050 '

for f in $@ 
do
   suff=${f: -3}
   command='/users/omkar/local/bin/ffmpeg -i '$f$OPTS${f%.$suff}'.mp4'   
	echo $command
   $command
done

