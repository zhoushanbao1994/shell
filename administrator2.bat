@ECHO OFF&PUSHD %~DP0 &TITLE �ж�DOS�������ļ��Ƿ��Թ���Ա����
::�÷�������һЩ��å����Ŀ�����..   ���ǲ���
::��&&�� �������������&&ǰ������ɹ�ʱ����ִ��&&������   
::��||�� �������������||ǰ������ʧ��ʱ����ִ��||������
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(Echo ��ʹ���Ҽ�����Ա������У�&&Pause >nul&&Exit)
Rd "%WinDir%\System32\test_permissions" 2>NUL
 
echo ��ǰ�ǹ���Ա������
pause >NUL && EXIT