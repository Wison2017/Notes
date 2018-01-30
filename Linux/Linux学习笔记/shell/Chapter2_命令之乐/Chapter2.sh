Chapter2 : 命令之乐
# ****************************** #
#2.2 用cat进行拼接

#cat读取文件内容的一般写法：
cat file1 file2 file3 ...

#cat从标准输入中进行读取：
echo 'Hello world!' | cat - file1.txt # -代表管道前的stdin

#cat 压缩空白行 使用 -s
cat -s filename # -s 可以将多行空白压缩成一行

#cat 压缩空白行 使用 tr
cat filename | tr -s '\n' #将连续多个'\n'替换成一个'\n'

#cat 将制表符显示为 ^I
cat -T filename

#cat 显示行号
cat -n filename

# ****************************** #
#2.3 录制与回放终端会话

script -t 2> timing.log -a output.session
type commands;
...
...
exit
#timing.log 用于存储时序信息，描述每一个命令在何时运行；
#output.session用于存储命令输出
#-t选项用于将时序数据导入stderr
#2>则用于将stderr重定向到timing.log
#回放命令：
scriptreplay timing.log output.session

#多个用户之间进行广播
#打开两个终端
#Terminal1
mkfifo scriptfifo

#Terminal2
cat scriptfifo

#Terminal1
script -f scriptfifo
commands
#如果想要结束的话就使用exit

# ****************************** #
# 文件查找与文件列表

#列出当前目录以及子目录下所有的文件和目录
find base_path

#在某个目录下寻找具体的文件名
find /etc -name "*.txt" 
# -iname 可以忽略大小写

#匹配多个条件中的一个，可以使用OR条件操作
$ ls
new.txt   some.jpg   text.pdf

$ find . \( -name "*.txt" -o -name "*.pdf" \) #注意空格

#-path 这个参数是以整个路径作为一个整体来匹配

find /home/users -path "*slynux*" 
#This will match files as following paths.
#Results:
/home/users/list/slynux.txt
/home/users/slynux/eg.css

# -regex 用于使用正则表达式来匹配
$ ls
new.PY  next.jpg  test.py
$ find . -regex ".*\(\.sh|\.py\)$"

#-iregex 可以忽略大小写


#否定参数 !
find . ! -name "*.txt" #找出所有不是以"*.txt"结尾的文件



#基于目录深度的搜索
# -mindepth 指定最小深度
# -maxdepth 指定最大深度

#在当前目录搜索
find . -maxdepth 1 -type f # -type f 指的是普通文件

#在第二级目录及以后
find . -mindepth 2 -type f 

#-maxdepth 和 -mindepth 应该作为 find 的第三个参数出现，这样子搜索效率更加高




# -type
普通文件    f
符号链接    l
目录        d
字符设备    c
块设备      b
套接字      s
Fifo        p




#根据文件时间进行搜索
-atime: 用户最近一次访问文件的时间  access time
-mtime: 文件内容最后一次被修改的时间 modify time
-ctime: 文件元数据，例如权限等 最后一次改变的时间

#example
#打印出最近七天内被访问过的所有文件
find . -type f -atime -7 

#打印出恰好在七天前被访问过的所有文件
find . -type f -atime 7 

#打印处访问时间超过七天的所有文件
find . -type f -atime +7

#
-amin (访问时间)
-mmin (修改时间)
-cmin (变化时间)

# -newer参数
find . -type f -newer file.txt #找出比file.txt更新的所有文件




#基于文件大小的搜索
find . -type f -size +2k  #找出大于2kb的文件
find . -type f -size -2k  #小于2kb的文件
find . -type f -size 2k   #等于2kb的文件

#
b ---- 块 512字节
c ---- 字节
w ---- 字(2字节)
k ---- 千字节
M ---- 兆字节
G ---- 吉字节




# -delete 可以用来删除 find 找到的文件
find . -type f -name "*.swp" -delete




# 基于文件权限和所有权的匹配
find . -type f -name "*.swp" -delete

find . -type f -name "*.php" ! -perm 644 #找出文件权限不是644的.php文件




#根据文件所属于的用户打印所有文件：
find . -type f -user eric 




# 使用-exec 与其他命令进行结合
find . -type f -user root -exec chown eric {} # 将 find 找到的所有的文件的所有权更改成 eric

find . -type f -name "*.c" -exec cat {} \;>all_c_files.txt  #将 find 找到的 c文件 输出到 all_c_files.txt 里面

find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD \; 将10天前的 .txt 文件复制到 OLD 目录中


# -exec 只能接一个命令，如果想要执行多个命令，可以接一个 shell 脚本文件
-exec ./commands.sh {} \;




# -exec 结合 printf
find . -type f -name "*.txt" -exec printf "Text file: %s\n" {} \;




# 让find 跳过特定的目录
find devel/source_path \( -name ".git" -prune \) -o \( -type f -print \)
#意思是：               排除 .git 目录                 






# ****************************** #
# 2.5 玩转xargs
# xargs 的优势：有些命令没有办法接受stdin的数据作为参数，这个时候可以使用 xargs ，它可以将 stdin 转换成参数


#将多行输入换成单行输出
cat example.txt | xargs

#将单行输入转换成多行输出
cat example.txt | xargs -n 3   # 3 个一行


#example1 
echo "splitXsplitXsplitXsplit" | xargs -d X

#example2
echo "splitXsplitXsplitXsplit" | xargs -d X -n 2

#example3
$ cat args.txt
arg1
arg2
arg3

$ cat cecho.sh
#!/bin/bash
echo $*'#'

cat args.txt | xargs -n 1 ./cecho.sh


# -I
cat args.txt | xargs -I {} ./cecho.sh -p {} -1



# 一个很危险的命令
find . -type f -name "*.txt" -print | xargs rm -f

# 有时候，一个文件的命令带有空格的话，例如 "hello world.txt", xargs 会误认为为两个文件，一个"hello"，一个"world.txt"
# 解决方法，使用 print0 , 
find . -type f -name "*.txt" -print0 | xargs -0 rm -f
#-print0 会以 ‘\0’ 分割每个文件名的字符串， 因为 -0 ，所以 xargs 会以 '\0' 定界符读取



# 统计源代码目录中所有C程序文件的行数
find source_code_dir_path -type f -name "*.c" -print0 | xargs -0 wc -l  



# subshell hack
cat files.txt | ( while read arg; do cat $arg; done )
# 等同于
cat files.txt | xargs -I {} cat {}








# ****************************** #
# 2.6 用 tr 进行转换
# tr 只能通过 stdin ，而无法通过命令行参数来接受输入
# 调用格式： tr [options] set1 set2

# 大写转换成小写
echo "HELLO WHO IS THIS" | tr 'A-Z' 'a-z'


# 使用 tr 加密和解密数字：
# 加密
echo 12345 | tr '0-9' '9876543210' 
# 输出 87654
# 解密
echo 87654 | tr '9876543210' '0-9'
# 输出 12345

# ROT13 加密算法 文本加密和解密都是使用同一个函数
#加密
echo "hello world" | tr "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
# 输出 uryyb jbeyq

#解密
echo "uryyb jbeyq" | tr "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" "NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"
# 输出 hello world



# 将制表符转换成空格
cat text | tr '\t' ' '



# 使用 tr 删除字符
echo "Hello 123 world 456" | tr -d '0-9'


# 字符集补集 -c
echo hello 1 char 2 next 4 | tr -d -c '0-9 \n'


# 压缩重复字符 -s
echo "GNU is not      UNIX. Recursive    right ?" | tr -s ' '
# 输出 "GNU is not UNIX. Recursive right ?"


# 用一种巧妙的方式将文件中的数字相加
$ cat sum.txt
1
2
3
4
5
$ cat sum.txt | echo $[ $( tr '\n' '+' ) 0 ]
$[ operation ] 执行算术运算





 
# ****************************** #
# 2.7 校验和与核实

md5sum filename > file_sum.md5

md5sum -c file_sum.md5

#SHA1 的用法跟md5相同，只需要将 md5sum 替换成 sha1sum


# 对目录下的多个文件进行校验
md5deep -rl directory_path > directory.md5
-r 使用递归的方式
-l 使用相对路径，默认是绝对路径

# 结合 find 来递归计算校验和
find directory_path -type f -print0 | xargs -0 md5sum >> directory.md5
# 核实
md5sum -c directory.md5




 
# ****************************** #
# 2.8 排序、单一与重复

sort file1.txt file2.txt > sorted.txt

cat sorted.txt | uniq> uniq_lines.txt

#按照数字进行排序
sort -n file.txt
-r 逆序
-M 按照月份

#检测一个文件是否已经排序
#!/bin/bash
sort -C file;
if [ $? -eq 0 ]; then
    echo Sorted;
else
    echo Unsorted;
fi
#如果要检测一个文件是否按数字进行排序，应该使用 sort -nC



#合并两个排过序的文件，而且不需要对合并后的文件在进行排序
sort -m sorted1 sorted2




#补充内容
cat data.txt
1 mac 2000
2 winxp 4000
3 bsd 1000
4 linux 1000

$ sort -nrk 1 data.txt
4 linux 1000
3 bsd 1000
2 winxp 4000
1 mac 2000
# -nrk 1 按照数字、逆序、第一列为key

# 使 sort 的输出与以 \0 作为参数终止符的 xargs 命令想兼容
sort -z data.txt | xargs -0

# -b 忽略文件中的前导空白字符，-d 用于指明以字典序进行排序
sort -bd unsorted.txt





# uniq 只能用于排过序的数据输入
uniq sorted.txt
# 等同于
sort unsorted.txt | uniq
# 等同于
sort -u unsorted.txt

#统计各行在文件出现的次数
sort unsorted.txt | uniq -c

#找出重复的行
sort unsorted.txt | uniq -d

# -s 指定可以跳过前 N个字符；
# -w 制定用于比较的最大字符数；
cat data.txt
u:01:gnu
d:04:linux
u:01:bash
u:01:hack

sort data.txt | uniq -s 2 -w 2



# 用 uniq 命令生成 '\0' 定界符的输出
uniq -z file.txt | xargs -0 rm



# 用 uniq 生成字符串样式
INPUT="ahebhaaa"
OUTPUT=`echo $INPUT | sed 's/[^.]/&\n/g'` | sed '/^$/d' | sort | uniq -c | tr -d ' \n'`
echo $OUTPUT




# ****************************** #
# 2.9 临时文件命令与随机数

# 该命令可以生成一个随机文件，例如 /tmp/fileabc，并将文件名赋给temp_file
temp_file=$(tempfile)

temp_file="/tmp/file-$RANDOM" # 利用 $RANDOM 生成一个随机数

temp_file="/tmp/var.$$" # $$是当前运行脚本的进程ID




# ****************************** #
# 2.10 分割文件和数据

# 生成一个大小为100 KB的测试文件
dd if=/dev/zero bs=100k count=1 of=data.file

# 分割文件
split -b 10k data.file

split -b 10k data.file -d -a 4   # -d 以数字为后缀，-a 4 数字长度为5


# 为分割后的文件指定文件名前缀
# 格式如下：
split [COMMAND_ARGS] PREFIX

split -b 10k data.file -d -a 4 split_file


# 以行数来分割文件
split -l 10 data.file



# 利用 csplit 来对 log 文件进行分割
# 示例文件 server.log
# 文件内容
SERVER-1
[connection] 192.168.0.1 success
[connection] 192.168.0.1 succes
[connection] 192.168.0.1 success
[connection] 192.168.0.1 success
SERVER-2
[connection] 192.168.0.1 success
[connection] 192.168.0.1 succes
[connection] 192.168.0.1 success
[connection] 192.168.0.1 success
SERVER-3
[connection] 192.168.0.1 success
[connection] 192.168.0.1 succes
[connection] 192.168.0.1 success
[connection] 192.168.0.1 success

csplit server.log /SERVER/ -n 2 -s {*} -f server -b "%02.log"; rm server00.log






# ****************************** #
# 2.11 根据扩展名切分文件名
# 获得 “名称.扩展名” 这个格式的文件名
file_jpg="sample.jpg"
name=${file_jpg%.*}    #   % 是从右边开始匹配，非贪婪；  %%是贪婪
echo File name is: $name


# 获得后缀
extension=${file_jpg#*.}  #  # 是从左边开始匹配，非贪婪；   ##是贪婪
echo Extension is: $extension







# ****************************** #
# 2.12 批量重命名和移动

# 用特定的格式重命名当前目录下的图像文件
# 脚本如下：
#!/bin/bash

count=1;
for img in *.jpg *.png
do
    new=img-$count.${img##*.}
    mv "$img" "$new" 2>/dev/null
    if [ $? -eq 0 ];
    then
         echo $img was renamed to $new
         let count++
    fi
done



# 其他重命名操作：
rename *.JPG *.jpg
rename 's/ /_/g' * 

# 转换文件名的大小写：
rename 'y/A-Z/a-z/' *
rename 'y/a-z/A-z/' *

# 将目录的 .mp3 文件移动特定的目录：
find path -type f -name "*.mp3" -exec mv {} target_dir \;

# 将所有文件名中的空格替换为字符 "_"
find path -type f -exec rename 's/ /_/g' {} \; 







# ****************************** #
# 2.13 拼写检查与字典操作
$ ls /usr/share/dict/
american-english british-english

#!/bin/bash
word=$1
grep "^$1$" /usr/share/dict/british-english -q # -q 抑制输出
if [ $? -eq 0 ]; then
     echo $word is a dictionary word.
else
     echo $word is not a dictionary word.
fi



# 使用aspell
#!/bin/bash
word=$1
output=`echo \"$word\" | aspell list`
if [ -z $output ];then      # -z 用于检测 $output 是否为空
    echo $word is a dictionary word;
else
    echo $word is not a dictionary word;
fi


# 列出文件中以特定单词起头的所有单词
look word filepath

# 或者
grep "^word" filepath




# ****************************** #
# 2.14 交互输入自动化

interactive.sh
#!/bin/bash
read -p "Enter a number:" no
read -p "Enter your name:" name
echo "Welcome NO:$no $name"

# 输入参数的第一种方法
echo -e "1\nhello\n" | ./interactive.sh

# 第二种方法
echo -e "1\nhello\n" > input.data
./interactive.sh < input.data

# expect 脚本实现自动化
-




























































