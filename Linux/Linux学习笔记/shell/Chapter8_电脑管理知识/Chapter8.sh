Chapter8 电脑管理知识
# ****************************** #
# 8.2 统计磁盘的使用情况
# du --> disk usage
# 找出某个文件或多个文件占用的磁盘空间
du FILENAME1 FILENAME2 ..

# 列出某个目录中所有文件的磁盘使用情况
du -a DIRECTORY

PS: 使用 du DIRECTORY 只会列出子目录的使用情况，不会具体的文件

# 以友好的方式显示大小
du -h FILENAME

# -s 该参数用于显示总大小

# -c 会在末尾加上一行total

# 默认以字节为单位
# -k 以 KB 为单位的大小
# -m 以 MB 为单位的大小
# -B 以 块 为单位的大小


# 从磁盘使用统计中排除部分文件
du --exclude "*.txt" FILES

# 从文件排除
du --exclude-from EXCLUDE.txt DIRECTORY

# 可以用 --max-depth 指定遍历目录层次的最大深度

# -x 可以限制 du 只对单个文件系统进行遍历


# 找出指定目录中最大的10个文件(包括目录)
du -ak SOURCE_DIR | sort -nrk 1 | head

# 找出指定目录中最大的10个文件(不包括目录)
find . -type f -exec du -k {} \; | sort -nrk 1 | head


# df --> disk free  磁盘的可用空间信息 





# ****************************** #
# 8.3 计算命令执行时间
time COMMAND

# 更加全面的time要使用 /usr/bin/time
/usr/bin/time -o output.txt COMMAND

# 不影响源文件的内容
/usr/bin/time -a -o output.txt COMMAND

# 格式化字符串输出时间
real -%e
user -%U
sys -%S

/usr/bin/time -f "FORMAT STRING" COMMAND
/usr/bin/time -f "TIME:%U" -a -o timing.log uname




# ****************************** #
# 8.4 与目前登录用户、启动日志及启动故障的相关信息
# 获取当前登录用户的相关信息
who
或者
w

# 列出当前登录主机的用户列表
users

users | tr ' ' '\n' | sort | uniq

# 查看系统通电时间
uptime

# 获取前一次的启动及用户登录回话的信息
last # last 以日志文件 /var/log/wtmp作为输入日志数据

# 可以使用 -f 指定日志文件
last -f /var/log/wtmp

# 获取重启回话信息
last reboot

# 获取失败的用户登录回话信息





# ****************************** #
# 8.5 打印出10条最常使用的命令
#!/bin/bash
printf "COMMAND\tCOUNT\n";
cat ~/.bash_history | awk '{ list[$1]++;} 
END{
   for(i in list)
   {
     printf("%s\t%d\n",i,list[i]);
   }
}' | sort -nrk 2 | head



# ****************************** #
# 8.6 列出1小时内占用CPU最多的10个进程

#!/bin/bash
SECS=3600
UNIT_TIME=60

STEPS=$(( $SECS / $UNIT_TIME ))

echo Watching CPU usage... ;

for ((i=0;i<STEPS;i++))
do
  ps -eo comm,pcpu | tail -n +2 >> /tmp/cpu_usage.$$
  sleep $UNIT_TIME
done

echo
echo CPU eaters :

cat /tmp/cpu_usage.$$ | awk '{process[$1]+=$2} 
END{
  for(i in process)
  {
    printf("%-20s %s", i, process[i]);
  }
}' | sort -nrk 2 | head




# ****************************** #
# 8.7 用watch监视命令输出
watch COMMAND
例如：
watch ls
watch 'ls -l | grep "^d"'

# 命令默认每2s更新一次输出,使用-n更改
watch -n 5 'ls -l'

# highlighting watch 输出中的差异
watch -d 'COMMANDS'




# ****************************** #
# 8.8 对文件及目录访问进行记录
sudo apt-get install inotify-tools

#
inotifywait -m -r -e create,move,delete DIRECTORY -q

# -m 表示持续监视变化，而不是变化发生之后就退出
# -r 允许采用递归形式监视目录
# -e 指定需要监视的时间列表
# -q 减少冗余信息





# ****************************** #
# 8.9 用logrotate管理日志文件
cat /etc/logrotate.d/program
/var/log/program.log{
missingok
notifempty
size 30k
  compress
weekly
  rotate 5
create 0600 root root
}
# /var/log/program.log 指定了日志文件路径
# missingok 如果日志文件丢失，则忽略；然后返回
# size 30k  仅当源日志文件非空时才对其进行轮替
# compress  限制实施轮替的日志文件的大小，可以用1M表示1MB
# weekly  指定进行轮替的时间间隔，可以是weekly,yearly 和daily
# rotate 5 这是需要保留的旧日志文件的归档数量，在这里指定的是5，所以这些文件名将是program.log.1.gz,program.log.2.gz等直到program.log.5.gz
# create 0600 root root 指定要创建的归档文件的模式，用户以及用户组





# ****************************** #
# 用syslog记录日志
/var/log/boot.log    系统启动信息
/var/log/httpd       Apache Web服务器日志
/var/log/message     发布内核启动信息
/var/log/auth.log    用户认证日志
/var/log/dmesg       系统启动信息
/var/log/mail.log    邮件服务器日志
/var/log/Xorg.0.log  X服务器日志



 

# ****************************** #
# 8.11 通过监视用户登录找出入侵者























































