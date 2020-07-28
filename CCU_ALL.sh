#!/bin/sh
# 注意文件Linux的编码格式（不要再Win下编辑）

# 输入Tftp Server Ip
tftp_server_default_ip="192.168.1.253"
read -p "输入 tftp server ip[默认为$tftp_server_default_ip]:" tftp_server_ip
if  [ ! -n "$tftp_server_ip" ] ;then
	# 输入值为空，使用默认值
	tftp_server_ip=$tftp_server_default_ip
fi
echo Tftp Server Ip $tftp_server_ip

device_default_network="192.168.1"
device_default_start_ip="101"
device_default_end_ip="188"

echo "默认网段:"$device_default_network

# 输入更新程序板子的起始地址
read -p "输入更新程序板子的起始ip的最后一位[默认为$device_default_start_ip]:" device_start_ip
if  [ ! -n "$device_start_ip" ] ;then
        # 输入值为空，使用默认值
	device_start_ip=$device_default_start_ip
fi

# 输入c更新程序板子的截至地址
read -p "输入更新程序板子的起始ip的最后一位[默认为$device_default_end_ip]:" device_end_ip
if  [ ! -n "$device_end_ip" ] ;then
	# 输入值为空，使用默认值
	device_end_ip=$device_default_end_ip
fi

echo $device_default_network.$device_start_ip - $device_default_network.$device_end_ip

# Telnet的用户密码
username="root"
password="root"

Cmd1="tftp -g -r CCU_Init.sh "$tftp_server_ip
Cmd2="chmod 755 CCU_Init.sh"
Cmd3="ls"
Cmd4="./CCU_Init.sh "
Cmd5="reboot"

# 循环访问设备，执行命令
for i in `seq $device_start_ip $device_end_ip`
do
	echo ""
	echo ""
	# 登录设备使用的IP
	login_ip=$device_default_network.$i
	echo "\033[31m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[32m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[33m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[34m ***************************************** $login_ip **************************************** \033[0m" 	

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
		echo $Cmd4 $tftp_server_ip 192.168.1.$i 192.169.1.$i
		sleep 5;
		echo $Cmd5
		sleep 2;
	#echo exit
	)|telnet $login_ip
#end
done

