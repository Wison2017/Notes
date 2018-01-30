#!/bin/bash
if [ $# -ne 2 ];
then
  echo "Usage: $0 filename str_length";
  exit -1;
fi
filename=$1
count=$(($2/2));
basepattern="/^";

for((i=1;i<=$count;i++))
do
   basepattern=$basepattern'\(.\)';
done

if [ $(($2%2)) -ne 0 ]
then
   basepattern=$basepattern'.';
fi

for((i=$count;i>=1;i--))
do
   basepattern=$basepattern'\'"$i";
done
set -x
basepattern=$basepattern'$/p'
set +x
sed -n $basepattern $filename

