#!/bin/bash
fpath="/etc"
if [ -d $fpath ]; then
echo File exists;
else
echo Does not exist;
fi
