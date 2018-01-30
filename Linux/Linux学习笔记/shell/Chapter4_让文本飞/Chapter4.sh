Chapter4 让文本飞
# ****************************** #
# 4.3 用 grep 在文件中搜索文本
用法：

grep match_pattern filename
或者
grep "match_pattern" filename
或者
echo -e "this is a word\nnext line" | grep word

# 多文件
grep "match_text" file1 file2 file3 ...

# 标记颜色
grep word filename --color=auto

# grep 通常将 match_pattern 视为通配符，如果要使用正则表达式，可以使用 grep -E 或者 egrep
# 例如：
grep -E "[a-z]+"

egrep "[a-z]+"

# 只输出匹配的文本部分,可以使用-o
echo this is a line. | grep -o -E "[a-z]+\."
或者
echo this is a line. | egrep -E "[a-z]+\."


# 打印除了match_pattern的行之外的行
grep -v match_pattern file


# 统计文件或文本中包含匹配字符串的行数, 
grep -c "text" filename

# -c 只是统计匹配的行数，而不是匹配的次数, 例如：
echo -e "1 2 3 4\nhello\n5 6" | egrep -c "[0-9]"
# result
2


# example
cat sample1.txt
gnu is not unix
linux is fun
bash is art

cat sample2.txt

planetlinux


grep linux -n sample1.txt
或者
cat sample1.txt | grep linux -n

grep linux -n sample1.txt sample2.txt


# example
# 打印样式匹配所位于的字符或字节偏移
echo gnu is not unix | grep -b -o "not"


# example
# 搜索多个文件并找出匹配文本位于哪一个文件中
grep -l linux sample1.txt sample2.txt
sample1.txt
sample2.txt
# -L 是 -l 的相反项，它会返回一个不匹配的文件列表


# 递归搜索文件
# 在多级目录中对文本进行递归搜索
grep "text" . -R -n

# 忽略样式中的大小写
echo hello world | grep -i "HELLO"

# 匹配多个样式
echo this is a line of text | grep -e "this" -e "line" -o

# 匹配多个样式的第二种方法：
# 生成样式文件
cat pat_file
hello
cool

echo hello this is cool | grep -f pat_file


# 在目录中递归搜索所有的.c和.cpp文件
grep "main()" . -r --include *.{c,cpp}

# 在搜索中排除所有的README文件：
grep "main()" . -r --exclude "README"

# 排除目录，使用 --exclude-dir
# 从文件中读取所需排除的文件列表，使用 --exclude-from FILE


# 使用 \0 值字节后缀的grep与xargs
echo "test" > file1
echo "cool" > file2
echo "test" > file3

grep "test" file* -lZ | xargs -0 rm



# grep的静默输出 -q
#!/bin/bash
if [ $# -ne 2 ];
then 
   echo "Please input: $0 match_pattern filename"
fi
match_pattern=$1
filename=$2
grep -q $match_pattern $filename
if [ $? -eq 0 ];
then
   echo "The file contains target!"
else
   echo "The file does not constain target!"
fi



# 打印出匹配文本之前或之后的行
seq 10 | grep 5 -A 3
seq 10 | grep 5 -B 3
seq 10 | grep 5 -C 3
echo -e "a\nb\nc\na\nb\nc" | grep a -A 1





# ****************************** #
# 4.4 用 cut 按列切分文件
# 提取文件某列或字段
cut -f FIELD_LIST filename
例如：
cut -f 2,3 filename

# cut 也能从stdin中读取输入文本
# 制表符是字段默认的定界符，可以使用 cut -s 避免打印打印不含定界符的行
cat student_data.txt
No      Name    Mark    Percent
1       Sarath  45      90
2       Alex    49      98
3       Anu     45      90
# 注意字段间用 tab 分隔


# 打印第一列
cut -f1 student_data.txt

# 打印第2,3列
cut -f2,3 student_data.txt

# 打印出除了第三列之外所有的列
cut -f3 --complement student_data.txt

# 指定字段的定界符
cut -f2 -d";" delimited_data.txt


# example
cat range_fields.txt
abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz
abcdefghijklmnopqrstuvwxyz

cut -c1-5 range_fileds.txt
cut range_fields.txt -c-2
cut range_fields.txt -c1-3,6-9 --output-delimiter ","





# ****************************** #
# 4.5 统计特定文件中的词频
#!/bin/bash
if [ $# -ne 1 ];
then
   echo "Usage: $0 filename";
   exit 1
fi

filename=$1

egrep -o "\b[[:alpha:]]+\b" $filename | \

awk '{ count[$0]++ } 
END{ printf("%-14s%s\n","Word","Count") ;
for(ind in count)
{ printf("%-14s%d\n",ind,count[ind]); }}'



# ****************************** #
# 4.6 sed入门 (stream editor)
# 文本替换
sed 's/pattern/replace_string/' file
或者
cat file | sed 's/pattern/replace_string/' file

# -i 将替换结果应用于源文件
sed -i 's/text/replace/' text

# 借助重定向来保存文件
sed 's/text/replace/' file > newfile


# 之前的都是每行的第一处，如果要全文的话，要使用：
sed 's/text/replace/g' file


# 忽略前 N 处匹配
echo this thisthisthis | sed 's/this/This/2g'


# 移除空白行
sed '/^$/d' file

# 已匹配字符串标记&
echo this is an example | sed 's/\w\+/[&]/g'

# 子字符串匹配标记\1
echo this is digit 7 in a number | sed 's/digit \([0-9]\)/\1/'
# result
this is 7 in a number

echo seven EIGHT | sed 's/\([a-z]\+\) \([A-Z]\+\)/\2 \1/'
# result 
EIGHT seven

# 组合多个表达式
sed 'expression1' | sed 'expression2'
等价于
sed 'expression1; expression2'

# 引用
表达式里面需要用到变量的时候，应该用 ""




# ****************************** #
# 4.7 awk 入门
awk 脚本的基本结构：
awk ' BEGIN{ print "start" } pattern {  commands } END{ print "end" } file'

# example
echo -e "line1\nline2" | awk 'BEGIN{ print "Start" } { print } END{ print "End" }'
# result
Start
line1
line2
End

# example
echo | awk '{ var1="v1"; var="v2"; var3="v3"; print var1,var2,var3 ;}'
# result
v1 v2 v3

# example
echo | awk '{ var1="v1"; var2="v2"; var3="v3"; print var1"-"var2"-"var3 ;}'
# result
v1-v2-v3


# 特殊变量
NR：
NF：
$0:
$1:
$2:
例如：
echo -e "line1 f2 f3 \nline2 f4 f5\nline3 f6 f7" | awk '{print "Line no:"NR",No of fields:"NF, "$0="$0, "$1="$1,"$2="$2,"$3="$3}'
# result
Line no:1,No of fields:3 $0=line1 f2 f3  $1=line1 $2=f2 $3=f3
Line no:2,No of fields:3 $0=line2 f4 f5 $1=line2 $2=f4 $3=f5
Line no:3,No of fields:3 $0=line3 f6 f7 $1=line3 $2=f6 $3=f7

# others
awk '{ print $3,$2 }' file
# 统计行数
awk 'END{ print NR }' file

# example
seq 5 | awk 'BEGIN{ sum=0; print "Summation:" } { print $1"+"; sum+=$1; } END{ print "=="; print sum }'

# -v 将外部变量传递给awk
VAR=10000
echo | awk -v VARIABLE=$VAR'{ print VARIABLE }'

# 将外部多个变量传递给awk
var1=“Variable1”; var2="Variable2"
echo | awk '{ print v1,v2 }' v1=$var1 v2=$var2

# 变量来自文件
awk '{ print v1,v2 }' v1=$var1 v2=$var2 filename

# getline
seq 5 | awk 'BEGIN { getline; print "Read ahead first line", $0 } { print $0 }'

# 用样式对awk处理的行进行过滤
awk 'NR < 5' # 行号小于5的行
awk 'NR==1,NR==4' #行号在1到5之间的行
awk '/linux/' #包含样式linux的行
awk '!/linux/' #不包含包含样式linux的行

# 默认的定界符时空格，可以使用 -F "delimiter" 明确指定一个定界符
awk -F: '{ print $NF }' /etc/passwd
或者
awk 'BEGIN { FS=":" } { print $NF }' /etc/passwd



# 从awk中读取命令输出
echo | awk '{ "grep root /etc/passwd" | getline cmdout ; print cmdout }'


# 在 awk 中使用循环
for(i=0;i<10;i++) { print $i; }
或者
for(i in array) { print array[i]; }



# ****************************** #
# 4.8 替换文本或文件中的字符串
# example
cat sed_data.txt
11 abc 111 this 9 file contains 111 11 88 numbers 0000
cat sed_data.txt | sed 's/\b[0-9]\{3\}\b/NUMBER/g'



# ****************************** #
# 4.9 压缩或解压缩JavaScript
cat sample.js
function sign_out()
{

$("#loading").show();
$.get("log_in",{logout:"True"},

function(){

window.location="";

});


}

# 压缩思路：
(1)移除'\n'和'\t'
tr -d '\n\t'
(2)移除多余的空格
tr -s ' '
或者
sed 's/[ ]\+/ /g'
(3)移除注释
sed 's:/\*.*\*/::g'
(4)移除{、}、(、)、；、：以及逗号前后的所有空格。
sed 's/ \?\([{},;:]\) \?/\1/g'

还原：
cat obfuscated.txt | sed 's/;/;\n/g; s/{/{\n\n/g; s/}/\n\n}/g' 




# ****************************** #
# 4.10 对文件中的行、单词和字符进行迭代
# 迭代文件中的每一行
while read line;
do 
echo $line;
done < file.txt
或者
cat file.txt | (while read line; do echo $line; done)


# 迭代一行中的每个单词
for word in $line
do 
echo $word;
done

# 迭代一个单词中的每一个字符
for((i=0;i<${#word};i++))
do
echo $(word:i:1);
done




# ****************************** #
# 4.11 按列合并文件
cat paste1.txt
1
2
3
4
5
cat paste2.txt
slynux
gnu
bash
hack

paste paste1.txt paste2.txt
1slynux
2gnu
3bash
4hack
5

# 默认的定界符是制表符,可以用 -d 指定
paste paste1.txt paste2.txt -d ","
1,slynux
2,gnu
3,bash
4,hack
5,




# ****************************** #
# 4.12 打印文件或行中的第n个单词或列
# 打印第 5 列
awk '{ print $5 }' filename




# ****************************** #
# 4.13 打印不同行或样式之间的文本
awk 'NR==M, NR==N' filename
cat filename | awk 'NR==M, NR==N'
seq 100 | awk 'NR==4,NR==6'
awk '/start_pattern/, /end_pattern/' filename






# ****************************** #
# 用脚本检验回文字符串
#!/bin/bash
if [ $# -ne 2 ];
then
  echo "Usage: $0 filename str_length";
  exit -1;
fi

count=$(($2/2));
basepattern="/^";

for (i=1;i<=$count;i++)
do
   basepattern=$basepattern'\(.\)';
done

if [ $(($2%2)) -ne 0 ]
then
   basepattern=$basepattern'.';
fi

for (i=$count;i>=1;i--)
do
   basepattern=$basepattern"\$i";
done

basepattern=$basepattern'$/p'
sed -n "$basepattern" $filename


# 其他方法: rev
#!/bin/bash
string="malayalam"
if [[ "$string" == "$(echo $string | rev)" ]];
then 
echo "Palindrome"
else
echo "Not palindrome"
fi

#
sentence='this is line from sentence'
echo $sentence | rev | tr ' ' '\n' | tac | tr '\n' ' ' | rev




# ****************************** #
# 4.15 以逆序形式打印行
tac file1 file2 ...
seq 5 | tac
seq 9 | awk '{ lifo[NR]=$0; lno=NR } END{ for(;lno>-1;lno--){ print lifo[lno]} }'




# ****************************** #
# 4.16 解析文本中的电子地址和URL
# 匹配一个电子邮件地址的egrep正则表达式：
[A-Z0-9.]+@[A-Z0-9a-z.]+\.[a-zA-Z]{2,4}

# 匹配一个HTTP URL的egrep正则表达式如下：
http://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,4}

# 在文件中移除包含某个单词的句子
sed 's/ [^.]*mobile phones[^.]*\.//g' sentence.txt



# ****************************** #
# 4.19 用awk实现head、tail、和tac

awk 'NR <= 10' filename

awk '{ buffer[NR % 10] =$0}'

# 模拟tail命令打印文件的后10行
awk '{ buffer[NR % 10] = $0;} END{ for(i=1;i<11;i++) { print buffer[i%10] } }' filename

# 模拟tac命令逆序打印输入文件的所有行
awk '{ buffer[NR] = $0; } END{ for(i=NR; i>0; i--) {print buffer[i]}}' filename


# ****************************** #
# 4.20 文本切片与参数操作
var="This is a line of text"
echo ${var/line/REPLACED}


string=abcdefghijklmnopqrstuvwxyz
echo ${string:4}
echo ${string:4:8}
echo ${string:(-1)}
echo ${string:(-2):2}
