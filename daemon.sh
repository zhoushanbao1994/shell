#! /bin/sh

#进程名称
PRO_NAME=CCU
# 重启进程时可执行文件的路径
PRO_PATH=/mnt/mmcblk0p3/CCU/

while true ;
do
	#用ps获取$PRO_NAME进程数量
	NUM=`ps aux | grep -w ${PRO_NAME} | grep -v grep |wc -l`
	echo $NUM

	#少于1，重启进程
	if [ "${NUM}" -lt "1" ];then
		echo "${PRO_NAME} was killed"
		nohup ${PRO_PATH}${PRO_NAME} >/dev/null 2>&1 &
	#大于1，杀掉所有进程，重启
	elif [ "${NUM}" -gt "1" ];then
		echo "more than 1 ${PRO_NAME},killall ${PRO_NAME}"
		killall -9 ${PRO_NAME}
		nohup ${PRO_PATH}${PRO_NAME} >/dev/null 2>&1 &
	fi

	#kill僵尸进程
	NUM_STAT=`ps aux | grep -w ${PRO_NAME} | grep T | grep -v grep | wc -l`
	if [ "${NUM_STAT}" -gt "0" ];then
		killall -9 ${PRO_NAME}
		nohup ${PRO_PATH}${PRO_NAME} >/dev/null 2>&1 &
	fi

	sleep 5s

done
 
exit 0