:: ���þ�̬IP��ַ

:: ip set address������IP��ַ
:: name=���������ӡ���ָ�����Ǹ����������ģ�ÿ���˵ĵ��Բ�ͬ�������Լ���������޸�
:: source=static��ָ�������õ��Ǿ�̬IP
:: addr��ָIP��ַ
:: maskָ��������
:: gatewayָĬ������
netsh interface ip set address name="��������" source=static addr=10.101.192.3 mask=255.255.255.0 gateway=10.101.192.1

:: ip set dns��ָ����DNS��������ַ
:: addr����ѡDNS������
netsh interface ip set dns name="��������" source=static addr=202.196.64.1

:: ���ö�̬IP��ַ
:: ͨ��DHCP��ȡIP��ַ
netsh interface ip set address name="��������" source=dhcp
netsh interface ip set dns name="��������" source=dhcp