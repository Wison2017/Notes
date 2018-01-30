#!/bin/bash
data="name,sex,location,rollno"
oldIFS=$IFS
IFS=","

for item in $data;
do
   echo Item: $item
done

IFS=$oldIFS
