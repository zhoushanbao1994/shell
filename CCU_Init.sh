##!/bin/bash
# 非标准Linux，BusyBox v1.27.0 (2017-07-09 22:05:31 CST)专用

echo "*****************************************************************************************"
#进程名称CCU
PRO_NAME=CCU
#用ps获取$PRO_NAME进程数量
NUM=`ps aux | grep -w ${PRO_NAME} | grep -v grep |wc -l`
#进程数量大于0，杀掉进程
if [ "${NUM}" -gt "0" ];then
	echo "Existing process: ${PRO_NAME},Killall ${PRO_NAME}"
	killall -9 ${PRO_NAME}
fi
echo "*****************************************************************************************"
#进程名称守护
PRO_NAME=daemon.sh
#用ps获取$PRO_NAME进程数量
NUM=`ps aux | grep -w ${PRO_NAME} | grep -v grep |wc -l`
#进程数量大于0，杀掉进程
if [ "${NUM}" -gt "0" ];then
	echo "Existing process: ${PRO_NAME},Killall ${PRO_NAME}"
	killall -9 ${PRO_NAME}
fi

echo "*****************************************************************************************"
# 进入目录 /mnt/mmcblk0p3/
work_path=/mnt/mmcblk0p3/
cd $work_path
echo Enter the directory:$work_path

# 获取当前工作路径
work_path=$(pwd)
echo $work_path

# 文件夹名
folder_name=CCU/

#如果CCU文件夹不存在，创建文件夹
if [ ! -d $folder_name ]; then
	echo Folder does not exist:$folder_name
	echo Create Folder:$folder_name
	mkdir $folder_name
else
	echo Folder already exists:$folder_name
fi

# 进入目录 folder_name
cd $folder_name

# 获取当前工作路径
work_path=$(pwd)
echo Current working path:$work_path

# TFTP传输文件
tftp_server_ip=192.168.1.253
file_name_1=CCU				# CCU可执行文件
file_name_2=daemon.sh		# 守护进程脚本
file_name_3=lib.zip			# libmodbus库文件
echo TFTP传输文件
tftp -g -r $file_name_1 $tftp_server_ip
tftp -g -r $file_name_2 $tftp_server_ip
tftp -g -r $file_name_3 $tftp_server_ip
echo TFTP传输文件结束

# 设置文件权限
echo Setting permissions:$file_name_1
chmod 755 $file_name_1
echo Setting permissions:$file_name_2
chmod 755 $file_name_2

# 解压库文件
echo Unzip files:$file_name_3
unzip $file_name_3
# 拷贝库文件至系统目录
cp lib/libmodbus.so lib/libmodbus.so.5 lib/libmodbus.so.5.0.5 /usr/lib/

###############################################################################################################
# 设置IP及自启代码
# 用户输入（IP地址的最后一个字节）
# 警告：此地址不要输错，否则可能无法连接设备
echo "*****************************************************************************************"
echo "Warning: Do not enter this address incorrectly, otherwise the device may not be connected"
echo "If you don't know the rules, you can exit with \"Ctrl+Z\""
echo "*****************************************************************************************"
read -p "Set Ip Last one: " ip
eth0_ip=192.168.1.$ip
eth1_ip=192.169.1.$ip
echo eth0 $eth0_ip
echo eth1 $eth1_ip

# 开机启动文件路径
start_file_name=/mnt/mmcblk0p2/autoStartRcs.sh
# 设置自启文件（非通用）
# 重新添加文件内容（IP地址会根据输入内容变化）
cat>$start_file_name<<EOF
#bin/sh
#This sh script is a hook for system start
	export PATH=$PATH:/mnt/mmcblk0p2/usr/bin

	/sbin/ifconfig eth0 down
	/sbin/ifconfig eth0 $eth0_ip
	/sbin/ifconfig eth0 netmask 255.255.255.0
	ethtool -s eth0 speed 100 duplex full  autoneg off
	/sbin/ifconfig eth0 up

	/sbin/ifconfig eth1 $eth1_ip
	/sbin/ifconfig eth1 netmask 255.255.255.0
	ethtool -s eth1 speed 100 duplex full  autoneg off
	/sbin/ifconfig eth1 up

	#test program configuration
	ifconfig can0 down
	canconfig can0 bitrate 125000
	canconfig can0 ctrlmode loopback off
	canconfig can0 start

	#######################################################
	#test for echo, when use can, should commented this one
	# canecho can0 &

	#cd /mnt/mmcblk0p3/zprg/
	
	#rs485 test,it is used for ttyO2, ttyO2 and ttyO5, when receive reach at 26 chars, then echo them
	#./rs485_ttyO2_test &
	#./rs485_ttyO3_test &
	#./rs485_ttyO5_test &
	
	#rs422 test,it is used for ttyO1
	#./rs422_ttyO1_test /dev/ttyO1&
	
	#cd /mnt/mmcblk0p3/zprg/
	#./ccu_brd_test   &
	# CCU
	$work_path/$file_name_1 &
	# Daemon
	$work_path/$file_name_2 &
EOF

echo end
echo "*****************************************************************************************"
