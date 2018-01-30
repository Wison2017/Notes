#!/bin/bash
word=$1
grep "^$1$" /usr/share/dict/british-english -q # -q 抑制输出
if [ $? -eq 0 ]; then
     echo $word is a dictionary word.
else
     echo $word is not a dictionary word.
fi
