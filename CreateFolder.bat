@echo off
@setlocal ENABLEEXTENSIONS
@setlocal ENABLEDELAYEDEXPANSION

:: ����������ر���
set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%

:: ��ǰbat�ļ�����·��
set current_path=%~dp0


:: ��0��ʼ��ÿ�μ�1��ѭ��100��
for /l %%i in (0,1,100) do (
	set /a mon=%%i
	echo !mon!
	call:functionname !mon!
)

pause



:: ����
:functionname
	:: ����Powershell�ṩ�ĺ������������ļ���ȡָ��������
	for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (Get-Date (Get-Date -year 2019 -month 1 -day 1)).AddMonths(%1) -uformat "%%Y-%%m-%%d"}"' ) do (
		set testdate=%%a
	)
	::echo %testdate%
	::set folder=%current_path%test\%testdate:~0,4%\%testdate:~0,7%\%testdate%\
	::set folder=%current_path%test\%testdate:~0,4%\%testdate:~0,7%\
	set folder=%current_path%test_%date:~0,10%\%testdate:~0,7%\
	echo !folder!

	:: �ж��ļ����Ƿ����
	if exist %folder% (
		echo %folder%�ļ��д���
	) else (
		:: ·�������ڻ�������֮�󴴽�Ŀ¼
		echo �½��ļ���%folder%
		mkdir %folder%
	)
goto:eof
