#!/bin/bash
CMD="command"
status 
$CMD
if [ $? -eq 0 ];
then 
  echo "$CMD executed successfully"
else
  echo "$CMD terminated unsuccessfully"
fi
