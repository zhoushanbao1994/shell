:: �Զ��Թ���Ա�������
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


::���ùرջ��Ժͱ����ӳ�
@echo off & setlocal EnableDelayedExpansion
::���ñ�������
title ����IP��ַ
::���ñ�����ɫ������ǳ��ɫ
color 0A


:: ��ȡ������������
echo ****************����������������****************
echo ***�������������д��ڿո��޷�ʹ�ã����޸�����***
set count=0
for /f "tokens=3*" %%a in ('netsh interface show interface^|more +2') do (
	:: ��¼��������
	set name[!count!]=%%b
	:: �����ۼ�
	set /a count+=1
)

:: ���Ʒ�Χ
set /a count-=1
for /l %%i in (0,1,!count!) do (
	echo %%i.!name[%%i]!
)
goto InputId

:InputId
set /p id=ѡ�����磨������ţ�:
for %%i in (1,1,100) do (
	if %id% geq 0 (
		if %id% leq %count% (
			:: ����ѭ����ִ������
			call:SetIp
		)
	)
	goto InputId
)

:SetIp
:: ����IP
set /p ip_addr=����IP:
:: �ַ����
for /f "tokens=1,2,3,4 delims=. " %%a in ('echo %ip_addr%') do (
	echo %%a %%b %%c %%d
	set ip_gateway_temp=%%a.%%b.%%c.1
)
:: ������������
set ip_mask_temp=255.255.255.0
set /p ip_mask_key=�����������루Ĭ��Ϊ%ip_mask_temp%��:
if defined ip_mask_key (
	:: �������ݲ�Ϊ��
	set ip_mask=%ip_mask_key%
) else (
	:: ��������Ϊ��
	set ip_mask=%ip_mask_temp%
) 
:: ��������
set /p ip_gateway_key=�������ص�ַ��Ĭ��Ϊ%ip_gateway_temp%��:
if defined ip_gateway_key (
	:: �������ݲ�Ϊ��
	set ip_gateway=%ip_gateway_key%
) else (
	:: ��������Ϊ��
	set ip_gateway=%ip_gateway_temp%
) 
echo name   :!name[%id%]!
echo ip     :%ip_addr%
echo mask   :%ip_mask%
echo gateway:%ip_gateway%
netsh interface ip set address name=!name[%id%]! source=static addr=%ip_addr% mask=%ip_mask% gateway=%ip_gateway%


pause >NUL && EXIT