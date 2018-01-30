#!/bin/bash

# 文件描述符和重定向
# 0 ----  stdin  (标准输入)
# 1 ----  stdout (标准输出)
# 2 ----  stderr (标准错误)

echo "This is a sample text1" > temp.txt
echo "This is sample text2" >> temp.txt

# > 和 >> 都可以将文本重定向到文件，但是前者会先清空文件，后再写入内容，后者会追加到现有文件尾部


# ********************************** #

# 当一个命令发生错误并退出时，它会返回一个非0的状态；成功返回0，可用$?查看

ls + > out.txt  #不会将错误信息重定向到out.txt,该命令只会将stdout重定向到文件

ls + 2> out.txt #这个命令就可以将strerr重定向到文件

cmd 2 > strerr.txt 1 > stdout.txt # 将strerr和stdout分别重定向到两个文件

cmd 2>&1 output.txt #将stderr转换成stdout，输出到一个文件

cmd &> output.txt #此命令等同于上一个

cmd 2> /dev/null #可以将错误信息输出到“黑洞”

#example
echo a1 > a1
cp a1 a2; cp a2 a3;
chmod 000 a1
cat a*
cat a* 2>err.txt

# ********************************** #
#经过重定向到文件之后，就没有什么内容可以给管道 （ | ），可以使用tee来提供一份重定向数据的副本。
#用法：command | tee FILE1 FILE2

cat a* | tee out.txt | cat -n #注意：tee只接受stdin的数据，默认tee会将文件的原来的内容覆盖

cat a* | tee -a out.txt | cat-n #加上 -a 就会追加在原来的内容后面

echo who is this | tee - 
# 输出：
# who is this
# who is this

# ********************************** #
# < 操作符用于将文件中读取至stdin
# > 操作符用于阶段模式的文件写入
# >> 追加模式的文件写入

#example1
echo this is a test line > input.txt
exec 3 < input.txt
cat <&3

#example2
exec 4>output.txt
echo newline >&4
cat output.txt

#example3
exec 5>>input.txt
echo appended line >&5
cat input.txt

# ********************************** #
# 数组
array_var=(1 2 3 4 5 6)
array_var[0]="test1"
array_var[1]="test2"
array_var[2]="test3"

echo ${array_var[0]}

index=5
echo ${array_var[$index]}

echo ${array_var[*]}  #打印出数组array_var所有的信息
echo ${array_var[@]}  #等同于上一行

echo ${#array_var[*]} #打印数组的长度

# 关联数组(有点像HashMap)
declare -A fruits_value
fruits_value=([apple]='100 dollars' [orange]='150 dollars')
fruits_value[banana]='200 dollars'
echo "Apple costs ${fruits_value[apple]}"

#列出数组的索引
echo ${!array_var[*]}
echo ${!array_var[@]}

# ********************************** #
#使用别名
alias install='sudo apt-get install'

#alias命令是暂时的，离开当前终端就无效了，可以将它放进~/.bashrc文件中，因为每一个新的shell进程生成时，都会执行 ~/.bashrc 中的命令
echo 'alias cmd="command seq"' >> ~/.bashrc

#删除别名: unalias

#另一种创建别名的方法：定义一个具有新名称的函数，并把它写入~/.bashrc
alias rm='cp $@ ~/backup; rm$@'

#新别名会覆盖旧别名

#使用 \command 可以对命令实施转移，使我们可以执行原来的命令

# ********************************** #
#获取终端信息
#获取终端的行数和列数
tput cols
tput lines

#打印处当前终端名
tput longname

#将光标移动到方位(100,100)处：
tput cup 100 100

#设置终端背景色, no 可以在0到7之间取值
tput setb no

#设置终端文本前景色
tput setf no

#设置文本样式为粗体
tput bold

#设置下划线的起止
tput smu1
tput rmu1

#删除当前光标位置到行位的所有内容
tput ed

#example for stty
#!/bin/bash
echo -e "Enter password:"
stty -echo
read password
stty echo
echo echo Password read.

# ********************************** #
date

date +%s

date --date "Thu Nov 18 08:07:21 IST 2010" +%s

#日期格式字符串列表
星期：  %a  %A
月：    %b  %B
日：    %d
固定格式日期： %D
年：    %y  %Y
小时：  %I或者%H
分钟：  %M
秒：    %S
纳秒：  %N
UNIX纪元时： %s

#example
date "+%d %B %Y"

#example take_take.sh 记录一组命令所花费的时间
#!/bin/bash
start=$(date +%s)
commans;
statements;

end=$(date +%s)
difference=$((end-start))
echo Time taken to execute commands is $difference seconds.

# ********************************** #
#在脚本中生成延时
#!/bin/bash
echo -n Count:
tput sc

count=0;
while true;
do 
if [ $count -lt 40 ];
then let count++;
sleep 1;
tput rc
tput ed
echo -n $count;
else exit 0;
fi 
done

# ********************************** #
#调试脚本
#!/bin/bash
for i in {1..6}
do
set -x
echo $i
set +x
done 
echo "Script executed"

# ********************************** #
#函数和参数
#用法：
functionName;
functionName arg1 arg2;

#example
fname()
{
  echo $1,$2;  访问参数1和参数2 
  echo "$@";   以列表的形式一次性打印所有参数 如："$1" "$2" "$3"
  echo "$*";   类似于$@, 但是参数被作为单个实体 如："$1c$2c$3",其中c是IFS的第一个字符
  return 0;    返回值
}

#递归函数
F()
{
  echo $1;
  F hello;
  sleep 1;
}

#递归函数之Fork炸弹
:(){ :|:& }; :

forkBomb(){ forkBomb | forkBomb &}; forkBomb

#导出函数
export -f fname

#读取命令返回值
echo $?

#向命令传递参数

command -pvk 1 file
command file -pvk 1

# ********************************** #
#读取命令序列输出
ls | cat -n > out.txt

#
cmd_output=$(ls | cat -n)
echo $cmd_output

#
cmd_output=`ls | cat -n`
echo $cmd_output

#
pwd;
(cd /bin; ls);
pwd;

# ********************************** #
#以不按回车键的方式读取字符"n"
read -n number_of_chars variable_name

#example
read -n 2 var
echo $var

#以不回显的方式读取密码：
read -s var

#显示提示信息：
read -p "Enter input:" var

#在特定时间限制内读取输出：
read -t timeout var

#example 2秒内读取输入
read -t 2 var

#用定界符结束输入行
iread -d delim_charvar

#example 当输入":"的时候结束
read -d ":" var

# ********************************** #
#字段分隔符和迭代器
data="name,sex,rollno,location"
oldFIS=$FIS
FIS=","
for item in $data;
do
echo Item: $item
done

IFS=$oldFIS

#example
#!/bin/bash
line="eric:x:1000:1000:Eric,,,:/home/eric:/bin/bash"
oldIFS=$IFS
IFS=":"
count=0
for item in $line
do
  [ $count -eq 0 ] user=$item
  [ $count -eq 6 ] shell=$item
  let count++;
done
IFS=$oldIFS
echo $user\'s shell is $shell;

#Bash 的循环类型
#for循环
for var in list;
do
    commands;
done
#list can be a string, or a sequence.
# echo {1..50} echo {a..z} echo {A..Z} echo {a..h}

#类似C语言的for循环
for((i=0;i<10;i++))
{
   commands; #使用变量$i
}

#while循环
while condition
do
    commands;
done

#until循环
x=0;
until [ $x -eq 9 ];
do 
  let x++;
  echo $x;
done

# ********************************** #
#比较与测试
#if
if condition;
then 
commands;
fi

#else if和else
if condition;
then commands;
elif condition;
then
     commands
else
    commands
fi

#逻辑运算符
[ condition ] && action
[ condition ] || action
-eq 等于
-ne 不等于
-gt 大于
-lt 小于
-ge 大于或等于
-le 小于或等于

[ $var1 -ne 0 -a $var2 -gt 2 ] -a代表逻辑与
[ $var -ne 0 -o $var2 -gt 2] -o代表逻辑或

#文件系统相关测试
[ -f $var ]:如果给定的变量包含正常的文件路径或文件名，则返回真
[ -x $var ]:如果给定的变量包含的文件可执行，则返回真
[ -d $var ]:如果给定的变量包含的是目录，则返回真
[ -e $var ]:如果给定的变量包含的是文件，则返回真
[ -c $var ]:如果给定的变量包含的是一个字符设备文件的路径，则返回真
[ -b $var ]:如果给定的变量包含的是一个块设备文件的路径，则返回真
[ -w $var ]:如果给定的变量包含的是可写，则返回真
[ -r $var ]:如果给定的变量包含的是可读，则返回真
[ -L $var ]:如果给定的变量包含的是一个符号链接，则返回真
#example
fpath="/etc/passwd"
if [ -e $fpath ]; then
   echo File exists;
else
   echo Does not exists;
fi

#字符串比较
#使用字符串比较的时候，最好使用双中括号
[[ $str1 = $str2 ]] #当str1等于str2时候，返回真
[[ $str1 == $str2 ]]
[[ $str1 != $str2 ]]
[[ $str1 > $str2 ]]
[[ $str1 < $str2 ]]
[[ -z $str1 ]] #如果str1包含的是空字符串，则返回真
[[ -n $str1 ]] $如果str1包含的是非空字符串，则返回真
# =前后各有一个空格的话，就是比较，如果没有空格的话就是赋值

# []里面的内容可以使用test
# example
if [ $var -eq 0 ]; 
then echo "True";
fi
#等同于：
if test $var -eq 0;
then echo "True";
fi



































































































