#!/bin/sh
# 注意文件Linux的编码格式（不要再Win下编辑）

if [ -n "$1" ]; then
	echo "start ip "$1
else
	echo "start ip null"
	exit
fi
if [ -n "$2" ]; then
	echo "end ip "$2
else
	echo "end ip null"
	exit
fi

# Telnet的用户密码
username="root"
password="root"

Cmd1="tftp -g -r CCU_Init.sh 192.168.1.253"
Cmd2="chmod 755 CCU_Init.sh"
Cmd3="ls"
Cmd4="./CCU_Init.sh"
Cmd5="reboot"

# 循环访问设备，执行命令
for i in `seq $1 $2`
do
	echo ""
	echo ""
	ip='192.168.1.'$i
	echo "\033[31m ***************************************** $ip **************************************** \033[0m" 
	echo "\033[32m ***************************************** $ip **************************************** \033[0m" 
	echo "\033[33m ***************************************** $ip **************************************** \033[0m" 
	echo "\033[34m ***************************************** $ip **************************************** \033[0m" 	

	#start
	(
		# 登录
		sleep 1;
 		echo $username;
 		sleep 1;
		echo $password;
		sleep 1;
		# 传输Init文件
		echo $Cmd1;
		sleep 5;
		# 增加权限
		echo $Cmd2;
		sleep 1;
		# 列出文件
		echo $Cmd3;
		sleep 1;
		# 执行Init脚本
		echo $Cmd4 $i
		sleep 5;
		echo $Cmd5
		sleep 2;
	#echo exit
	)|telnet $ip
#end
done

