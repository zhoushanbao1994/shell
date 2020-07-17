@echo off & setlocal ENABLEEXTENSIONS

:: 利用Powershell提供的函数，批处理文件获取前一天的日期
for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (Get-Date).AddDays(-1) -uformat "%%Y%%m%%d"}"' ) do (
	set date1=%%a
)
echo %date1%

:: 利用Powershell提供的函数，批处理文件获取前一月的日期
for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (Get-Date).AddMonths(-1) -uformat "%%Y%%m%%d"}"' ) do (
	set date2=%%a
)
echo %date2%

:: 利用Powershell提供的函数，批处理文件获取前一年的日期
for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (Get-Date).AddYears(-1) -uformat "%%Y%%m%%d"}"' ) do (
	set date3=%%a
)
echo %date3%

:: 利用Powershell提供的函数，批处理文件获取指定的日期
for /f "delims=" %%a in ( 'PowerShell  "&{Get-Date (get-date -year 2000 -month 12 -day 31) -uformat "%%Y%%m%%d"}"' ) do (
	set date4=%%a
)
echo %date4%

pause