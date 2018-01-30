#!/bin/bash
if [ $# -ne 2 ];
then
   echo "Please input like this: $0 match_pattern filename"
fi
match_pattern=$1
filename=$2
grep -q $match_pattern $filename
if [ $? -eq 0 ]
then
   echo "The file contains the target!"
else
   echo "The file does not contain the target!"
fi


