#!/bin/sh
# 注意文件Linux的编码格式（不要再Win下编辑）

# 登录板子的原始IP
device_default_ip="192.168.1.100"
read -p "输入登录板子的原始IP[默认为$device_default_ip]:" device_ip
if  [ ! -n "$device_ip" ] ;then
        # 输入值为空，使用默认值
        device_ip=$device_default_ip
fi
echo Login Device IP：$device_ip

# 输入Tftp Server Ip
tftp_server_default_ip="192.168.1.253"
read -p "输入 tftp server ip[默认为$tftp_server_default_ip]:" tftp_server_ip
if  [ ! -n "$tftp_server_ip" ] ;then
        # 输入值为空，使用默认值
        tftp_server_ip=$tftp_server_default_ip
fi
echo Tftp Server IP: $tftp_server_ip



# 板子网口0要修改IP的网段
device_eth0_default_network="192.168.1"
read -p "输入板子网口0要修改IP的网段[默认为$device_eth0_default_network]:" device_eth0_network
if  [ ! -n "$device_eth0_network" ] ;then
        # 输入值为空，使用默认值
        device_eth0_network=$device_eth0_default_network
fi
# 板子网口1要修改IP的网段
device_eth1_default_network="192.169.1"
read -p "输入板子网口1要修改IP的网段[默认为$device_eth1_default_network]:" device_eth1_network
if  [ ! -n "$device_eth1_network" ] ;then
        # 输入值为空，使用默认值
        device_eth1_network=$device_eth1_default_network
fi

echo 即将要设置板子的网段为：$device_eth0_network $device_eth1_network


# Telnet的用户密码
username="root"
password="root"

Cmd1="tftp -g -r CCU_Init.sh"
Cmd2="chmod 755 CCU_Init.sh"
Cmd3="ls"
Cmd4="./CCU_Init.sh"
Cmd5="reboot"

# 循环访问设备，执行命令
while [ 1 ]
do
	echo ""
	echo ""
	login_ip=$device_ip
	echo "\033[31m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[32m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[33m ***************************************** $login_ip **************************************** \033[0m" 
	echo "\033[34m ***************************************** $login_ip **************************************** \033[0m" 	

	ping -c 1 $login_ip > /dev/null 2>&1
        if [ $? -eq 0 ];then
                echo " 检测网络正常"
        else
                echo "\033[31m ******************************** $login_ip 检测网络连接异常 ******************************** \033[0m"
                sleep 1
		continue
        fi

	echo 即将修改板子的IP地址网段为：$device_eth0_network $device_eth1_network
	
	# 板子网口要修改IP的最后一位
	device_default_end_ip="100"
	read -p "板子网口要修改IP的最后一位[默认为$device_default_end_ip]:" device_end_ip
	if  [ ! -n "$device_end_ip" ] ;then
		# 输入值为空，使用默认值
		device_end_ip=$device_default_end_ip
	fi
	echo 板子即将更新初始化CCU的相关功能，并修改IP为$device_eth0_network.$device_end_ip $device_eth1_network.$device_end_ip

	read -p "是否继续Y/N[默认为N]:" status
	if  [ ! -n "$status" ] ;then
		# 输入值为空，使用默认值
		continue
	fi
	if  [ "$status" == "N" ] ;then
		# 输入值为N
		continue
	fi
	
	#start
	(
		# 登录
		sleep 1;
 		echo $username;
 		sleep 1;
		echo $password;
		sleep 1;
		# 传输Init文件
		echo $Cmd1 $tftp_server_ip;
		sleep 5;
		# 增加权限
		echo $Cmd2;
		sleep 1;
		# 列出文件
		echo $Cmd3;
		sleep 1;
		# 执行Init脚本
		echo $Cmd4 $tftp_server_ip $device_eth0_network.$device_end_ip $device_eth1_network.$device_end_ip
		sleep 5;
		echo $Cmd5
		sleep 2;
	#echo exit
	)|telnet $login_ip
	#end
	
	sleep 5
done


