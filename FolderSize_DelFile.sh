#!/bin/bash

if [ $# -ne 2 ]; then
	echo "argv != 2"
	exit
fi
if [ ! -d $1 ]; then
	echo "$1    Folder not exist!"
	exit
fi
if [ ! -n "$(echo $2 | sed -n "/^[0-9]\+$/p")" ]; then 
	echo "$2    is not number!"
	exit 
fi

#FOLDER="/userdata/xxx/"# path
#MAX_MB=1		# max size MB
FOLDER=$1 		# path
MAX_MB=$2               # max size MB

MAX_SIZE=`expr $MAX_MB \* 1024`  		# max size KB

function demoFun1()
{
	files=$(ls $FOLDER)
	for filename in $files
        do
		SIZE=$(du -s $FOLDER | awk '{ print $1 }')
		if [ $SIZE -gt $MAX_SIZE ];then
			name=$FOLDER$filename
			echo $SIZE " > " $MAX_SIZE " --- rm $name"
			rm $name
			sleep 1s
		else
			echo $SIZE " <= " $MAX_SIZE
			break
		fi
	done
}

demoFun1

