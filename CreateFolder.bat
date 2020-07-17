@echo off
@setlocal ENABLEEXTENSIONS
@setlocal ENABLEDELAYEDEXPANSION

:: 设置日期相关变量
set year=%date:~0,4%
set month=%date:~5,2%
set day=%date:~8,2%

:: 当前bat文件所在路径
set current_path=%~dp0


:: 从0开始，每次加1，循环100次
for /l %%i in (0,1,100) do (
	set /a mon=%%i
	echo !mon!
	call:functionname !mon!
)

pause



:: 函数
:functionname
	:: 利用Powershell提供的函数，批处理文件获取指定的日期
	for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (Get-Date (Get-Date -year 2019 -month 1 -day 1)).AddMonths(%1) -uformat "%%Y-%%m-%%d"}"' ) do (
		set testdate=%%a
	)
	::echo %testdate%
	::set folder=%current_path%test\%testdate:~0,4%\%testdate:~0,7%\%testdate%\
	::set folder=%current_path%test\%testdate:~0,4%\%testdate:~0,7%\
	set folder=%current_path%test_%date:~0,10%\%testdate:~0,7%\
	echo !folder!

	:: 判断文件夹是否存在
	if exist %folder% (
		echo %folder%文件夹存在
	) else (
		:: 路径不存在或重命名之后创建目录
		echo 新建文件夹%folder%
		mkdir %folder%
	)
goto:eof
