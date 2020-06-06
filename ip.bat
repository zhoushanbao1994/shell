:: 设置静态IP地址

:: ip set address是设置IP地址
:: name=“本地连接”是指你用那个连接上网的，每个人的电脑不同，根据自己的情况来修改
:: source=static是指，你设置的是静态IP
:: addr是指IP地址
:: mask指子网掩码
:: gateway指默认网关
netsh interface ip set address name="本地连接" source=static addr=10.101.192.3 mask=255.255.255.0 gateway=10.101.192.1

:: ip set dns是指设置DNS服务器地址
:: addr是首选DNS服务器
netsh interface ip set dns name="本地连接" source=static addr=202.196.64.1

:: 设置动态IP地址
:: 通过DHCP获取IP地址
netsh interface ip set address name="本地连接" source=dhcp
netsh interface ip set dns name="本地连接" source=dhcp