Chapter7 网络知识
# ****************************** #
# 7.2 新手上路
ifconfig

# 补充内容
# 1: 打印网络接口列表
ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n'

# 打印特定网络接口列表
ifconfig iface_name

# 打印ip地址：
ifconfig enp7s0 | egrep -o "inet 地址:[^ ]*" | grep -o "[0-9.]*"

# 设置ip地址：
ifconfig enp7s0 172.29.109.129

# 设置IP地址的子网掩码：
ifconfig enp7s0 172.29.109.129 netmask 255.255.252.0

# 更改MAC地址：
ifconfig enp7s0 

# DNS (Domain Name Service,域名服务)
# 查看当前系统的名字服务器
cat /etc/resolv.conf

# 手动添加名字服务器：
echo nameserver IP_ADDRESS >> /etc/resolv.conf

# 获得域名对应的IP地址, 一个域名可能有多个地址，这个命令只会返回一个
ping google.com

# 如果想要返回所有的域名所有的IP地址，需要用DNS查找工具
host baidu.com

nslookup baidu.com

# 如果不使用DNS服务器，也可以为IP地址解析添加符号名，需添加到/etc/hosts
echo 192.168.0.9 backupserver.com >> /etc/hosts


# 设置默认网关，显示路由表信息
route
或者
route -n

# 设置默认网关
# 语法：
route add default gw IP_ADDRESS INTERFACE_NAME
例如：
route add default gw 192.168.0.1 enp7s0

# Traceroute 显示分组途径的所有网关地址
traceroute google.com






# ****************************** #
# 7.3 使用ping
# ping 命令使用互联网控制消息协议 ICMP的echo分组, 当这些echo 分组发送到某个主机时，如果分组能够送达切该主机为活动主机，那么他就会发送一条回应
ping ADDRESS


# 往返时间 (RTT, round trip time)
PING localhost (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.035 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.045 ms
64 bytes from localhost (127.0.0.1): icmp_seq=3 ttl=64 time=0.091 ms
64 bytes from localhost (127.0.0.1): icmp_seq=4 ttl=64 time=0.031 ms
64 bytes from localhost (127.0.0.1): icmp_seq=5 ttl=64 time=0.095 ms
^C
--- localhost ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4093ms
rtt min/avg/max/mdev = 0.031/0.059/0.095/0.028 ms


# 限制发送的分组数量
ping baidu.com -c 2



# 列出网络上所有的活动主机
#!/bin/bash
for ip in 172.29.109.{1..255};
do 
   ping $ip $> /dev/null;
   if [ $? -eq 0 ];
   then
      echo $ip is alive
   fi
done

# 多线程版本
#!/bin/bash
for ip in 172.29.109.{1..255};
do
   (ping $ip -c 2 &> /dev/null;
    if [ $? -eq 0 ];
    then
      echo $ip is alive;
    fi
)&
done
wait


# 或者使用
 fping -a 172.29.109.1 172.29.109.255 -g

-a 指定打印所有活动主机的IP地址
-u 指定打印处所有无法到达的主机
-g 指定从写作IP/mask的“斜线-子网掩码”记法或者起止IP地址记法中生成IP地址范围；




# ****************************** #
# 7.5 传输文件
# 连接 FTP 服务器传输文件
lftp username@ftphost






# ****************************** #
# 7.11 网络流量和端口分析
# 列出系统中开放端口以及运行在端口上的服务的详细信息
lsof -i

# 列出本地主机当前的开放端口：
lsof -i | grep ":[0-9]\+->" -o | grep "[0-9]\+" -o | sort | uniq


# 用netstat -tnp 列出开放端口与服务
netstat -tnp






