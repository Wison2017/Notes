Chapter3 以文件之名
# ****************************** #
# 3.2 生成任意大小的文件
dd if=/dev/zero of=junk.data bs=1M count=1
if=input file 
of=output file
bs=block size (Byte)

参考表格：
字节  （1B）   ---- c
字    （2B）   ---- w
块    （512B ）---- b
千字节（1024B）---- k
兆字节（1024KB）---- M
吉字节（1024MB）---- G


# ****************************** #
# 3.3 文本文件的交集和差集
  A(1,2,3) B(3,4,5)
# 交集：打印出两个文件所共有的行
  result=(3)
# 求差：打印出指定文件所包含的且不相同的那些行
  result=(1,2,4,5)
# 差集：打印出包含在文件A中，但不包含在其他指定文件中的那些行
  result=(1,2)
# command 必须使用排过序的文件作为输出
$ cat A.txt
apple
orange
gold
silver
steel
iron

$ cat B.txt
orange 
gold
cookies
carrot

sort A.txt -o A.txt;
sort B.txt -o B.txt;
comm A.txt B.txt

#result
apple
	carrot
	cookies
		gold
iron
		orange
silver
steel
#第一列为只有A.txt出现的行，第二列为只有B.txt出现的行，第三列为A.txt和B.txt共同有的行
-1 -2 -3 这些参数可以分别删除1,2,3行


# 将第一列和第二列合并
comm A.txt B.txt -3 | sed 's/^\t//'
# result
apple
carrot
cookies
iron
silver
steel





# ****************************** #
# 3.4 查找并删除重复文件
# 准备工作：
echo "hello" > test
cp test test_copy1
cp test test_copy2
echo "next" > other

这里需要用到 awk 命令，等学到第四章再回来看一下。






# ****************************** #
# 3.5 创建长路径目录
mkdir -p /home/slynux/test/hello/child 
-p 可以忽略所有已存在的目录，同时创建缺失的部分




# ****************************** #
# 3.6 文件权限、所有权和粘滞位
u = 指定用户权限
g = 指定用户组权限
o = 指定其他用户权限

# 更改文件的所有权
chown user.group filename

# 设置粘滞位，使得只有目录的所有者才能删除目录中的文件
chmod a+t directory_name

# 以递归的方式设置权限
chmod 777 directory_name -R

# 以递归的方式设置所有权
chmod user.group directory_name -R

# 设置 setuid 的特殊文件权限
chown root.root executable_file
chmod +s executable_file
# 这样子，文件每次都是以超级用户的身份来执行
# setuid 只能应用于Linux ELF格式的二进制文件




# ****************************** #
# 3.7 创建不可修改文件
sudo chattr +i file




# ****************************** #
# 3.8 批量生成空白文件
for name in {1..100}.txt
do 
touch $name
done

# 更改文件的时间戳
touch -a
touch -m




# ****************************** #
# 3.9 查找符号连接及其指向目标
用法：
ln -s target symbolic_link_name
例如：
ln -l -s /var/www/ ~/web

# 找出为 l 类型的文件名
ls -l | grep "^l" | awk '{ print $9 }'
find . -type l -print

# 打印出符号连接的指向目标
ls -l web | awk '{ print $10 }'
readlink web




# ****************************** #
# 3.10 列举文件类型统计信息

# 打印文件信息
file filename
file -b filename

#!/bin/bash

if [ $# -ne 1 ];
then 
   echo $0 basepath;
   echo
fi
path=$1

declare -A statarray;

while read line;
do 
   ftype=`file -b "$line"`
   let statarray["$ftype"]++;
done< <(find $path -type f -print)

echo ======== File types and counts ========
for ftype in "${!statarray[@]}";
do 
  echo $ftype : ${statarray["$ftype"]}
done




# ****************************** #
# 3.11 环回文件与挂载

# 创建一个 1GB 大小的文件：
dd if=/dev/zero of=loopbackfile.img bs=1G count=1
# 用 mkfs 命令格式化这个文件
mkfs.ext4 loopbackfile.img
暂时用不着。。。。




# ****************************** #
# 3.12 生成ISO文件及混合ISO

# 创建ISO文件的两种方法：
# 1：
cat /dev/cdrom > image.iso

# 2:
dd if=/dev/cdrom of=image.iso

mkisofs -V "Label" -o image.iso source_dir/
 





# ****************************** #
# 3.13 查找文件差异并进行修补
diff version1.txt version2.txt

diff -u version1.txt version2.txt

diff -u version1.txt version2.txt > version.patch

patch -p1 version1.txt < version.patch
#使得 version1.txt 变成 version2.txt

patch -p1 version1.txt < version.patch
#使得 version1.txt 变成原来的 version1.txt

diff 也可以用于目录
diff -Naur directory1 directory2




# ****************************** #
# 3.14 head 与 tail 打印文件的前10行和后10行

head file

cat text | head

head -n 4 file

head -n -N file

seq 11 | head -n -5 # 最后5行以外所有的行

seq 100 | head -n 5



#
tail file

cat text | tail

tail -n 5 file

tail -n  +(N+1) # 打印除了前N行之外所有的行

tail -f growing_file # 跟踪打印一个文件的尾部，常用于文件内容不断改变

dmesg | tail -f

# example 
PID=$(pidof gedit)
tail -f file.txt --pid $PID





# ****************************** #
# 3.15 只列出目录的其他方法

ls -d */

ls -aF | grep "/$"

ls -al | grep "^d"

find . type d -maxdepth 1 -print




# ****************************** #
# 3.16 在命令行中用 pushd 和 popd 快速定位
将常用的 directory 压入栈里面，例如：
有 /tmp/hello  /home/eric  /etc/haha

# 压入栈中
pushd /tmp/hello;
pushd /home/eric;
pushd /etc/haha;

# 查看栈里面的目录
dirs

# 切换目录
pushd +n # n 应该从0开始数

# 移除栈顶目录，并切换
popd

popd +no


# ****************************** #
# 3.17 统计文件的行数，单词数和字符数

# 统计行数
wc -l file

cat file | wc -l

# 统计单词数
wc -w file

cat file | wc -w

# 统计字符数
wc -c file

cat file | wc -c


echo -n 1234 | wc -c
# 使用 -n 可以避免添加额外的换行符

# 大荟萃
wc file




# 打印最长行的长度
wc file -L




# ****************************** #
# 3.18 打印目录树
tree directory

tree directory -P "*.sh"

tree directory -I PATTERN

tree -h

# 以 html 形式输出目录树 
tree . -H . -o out.html

