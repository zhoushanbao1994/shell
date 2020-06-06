:: 自动以管理员身份运行
@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )


::设置关闭回显和变量延迟
@echo off & setlocal EnableDelayedExpansion
::设置标题文字
title 设置IP地址
::设置背景黑色，字体浅绿色
color 0A


:: 获取网络连接名称
echo ****************本机网络连接名称****************
echo ***若网络连接名中存在空格无法使用，请修改名称***
set count=0
for /f "tokens=3*" %%a in ('netsh interface show interface^|more +2') do (
	:: 记录网络名称
	set name[!count!]=%%b
	:: 计数累加
	set /a count+=1
)

:: 限制范围
set /a count-=1
for /l %%i in (0,1,!count!) do (
	echo %%i.!name[%%i]!
)
goto InputId

:InputId
set /p id=选择网络（输入序号）:
for %%i in (1,1,100) do (
	if %id% geq 0 (
		if %id% leq %count% (
			:: 跳出循环，执行其他
			call:SetIp
		)
	)
	goto InputId
)

:SetIp
:: 输入IP
set /p ip_addr=输入IP:
:: 字符拆分
for /f "tokens=1,2,3,4 delims=. " %%a in ('echo %ip_addr%') do (
	echo %%a %%b %%c %%d
	set ip_gateway_temp=%%a.%%b.%%c.1
)
:: 输入子网掩码
set ip_mask_temp=255.255.255.0
set /p ip_mask_key=输入子网掩码（默认为%ip_mask_temp%）:
if defined ip_mask_key (
	:: 输入内容不为空
	set ip_mask=%ip_mask_key%
) else (
	:: 输入内容为空
	set ip_mask=%ip_mask_temp%
) 
:: 输入网关
set /p ip_gateway_key=输入网关地址（默认为%ip_gateway_temp%）:
if defined ip_gateway_key (
	:: 输入内容不为空
	set ip_gateway=%ip_gateway_key%
) else (
	:: 输入内容为空
	set ip_gateway=%ip_gateway_temp%
) 
echo name   :!name[%id%]!
echo ip     :%ip_addr%
echo mask   :%ip_mask%
echo gateway:%ip_gateway%
netsh interface ip set address name=!name[%id%]! source=static addr=%ip_addr% mask=%ip_mask% gateway=%ip_gateway%


pause >NUL && EXIT