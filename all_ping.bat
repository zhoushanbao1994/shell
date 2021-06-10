@echo off

:: IP网段
set ip1=192.168.1.
set ip2=192.168.2.

::起始地址
set start=101
::结束地址
set end=102

::获取当前路径
set mypath=%~dp0
echo %mypath%
::以日期时间创建文件夹
set folder=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~0,2%%time:~3,2%%time:~6,2%
md %folder%

cd\
cls

for /L %%i in (%start%,1,%end%) do (
    start cmd /k "TITLE Ping %ip1%%%i&&color 02&&mode con cols=120 lines=4&&echo Ping output result to file %ip1%%%i -- %mypath%%folder%\%ip1%%%i.txt&&ping %ip1%%%i -t >%mypath%%folder%/%ip1%%%i.txt"
    TIMEOUT /T 1
)
for /L %%i in (%start%,1,%end%) do (
    start cmd /k "TITLE Ping %ip2%%%i&&color 02&&mode con cols=120 lines=4&&echo Ping output result to file %ip2%%%i -- %mypath%%folder%\%ip2%%%i.txt&&ping %ip2%%%i -t >%mypath%%folder%/%ip2%%%i.txt"
    TIMEOUT /T 1
)
pause
