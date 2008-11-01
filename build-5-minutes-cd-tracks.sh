#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Syntax: $0 <file.mp3>"
  exit
fi
file=$1

# cdrdao blank --device /dev/scd0 -n -v 2

cd=cd-5-minute-tracks-without-gaps.wav
toc=cd-5-minute-tracks-without-gaps.txt

# many voice mp3 just have one channel and 22.5MHz or less
# we must "expand" it
mplayer -srate 44100 -af channels=2 -vc null -vo null -ao pcm:file=$cd $file

echo
echo -n ...Writing TOC...
echo CD_DA > $toc

# TODO: get time from mp3 automatically
# time length of file
minutes=62

for ((i=0; i < $minutes ; i+=5)); do
  S=$i:0:0;
  E=5:0:0;
  if [ $(($i+5)) -gt "$minutes" ] ; then 
    E=
  fi
  echo TRACK AUDIO >> $toc;
  echo FILE \"$cd\" $i:0:0 $E >> $toc;
  echo >> $toc;
done

echo OK

# cdrdao write $toc

