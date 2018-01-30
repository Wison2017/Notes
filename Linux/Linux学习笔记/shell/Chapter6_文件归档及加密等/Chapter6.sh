Chapter6 文件归档及加密等
# ****************************** #
# 6.2 用tar归档

# 将file1,file2,file3,和folder1归档到output.tar
tar -cf output.tar file1 file2 file3 folder1 ...


# 往归档文件中添加文件
tar -rvf original.tar new_file

# 列出归档文件里面的内容
tar -tf archive.tar

# 在列出归档文件内容的时候，显示更多详细的信息
tar -tvvf archive.tar

# 从压缩文档提取文件
tar -xf archive.tar

# 提取文件到指定目录
tar -xf archive.tar -C directory

# 提取压缩文档里面的指定文件
tar -xvf file.tar file1 file4  -v 用于显示提取进度等信息

# 在tar 中使用 stdin 和 stdout
tar -cf - file1 file2 file3 | tar -xvf - -C directory

# 拼接两个tar文件，把 file2.tar 拼接 到 file1.tar
tar -Af file1.tar file2.tar
tar -tvf file1.tar


# 通过检查时间戳来更新归档文件中的内容
tar -tf archive.tar
# result
filea 
fileb
filec

# 只有filea的文件内容修改时间更新的时候才对它进行修改
tar -uvvf archive.tar filea

# 修改文件的时间戳
touch


# 比较归档文件与文件系统中的内容
tar -df archive.tar afile bfile
# result
afile: Mod time differs
bfile: Size differs


# 从归档文件中删除文件
tar -f archive.tar --delete file1 file2 ..
或者
tar --delete --file archive.tar filea


# 压缩tar归档文件
-j 指定bzip2格式；
-z 指定gzip格式
--lzma 指定lzma格式
-a 自动根据文件拓展名自动进行压缩

# 从归档中排除部分文件
tar -cf archive.tar * --exclude "*.txt"

# 将需要排除的文件名放在文件中
cat list
filea 
fileb

tar -cf arch.tar * -X list


# 排除版本控制目录
tar --exclude-vcs -czvvf source_code.tar.gz eye_of_gnome_svn


# 打印总字节数
tar -cf arc.tar * --exclude "*.txt" --totals





# ****************************** #
# 6.3 用cpio归档
# 将多个文件和文件夹存储为单个文件，同时保留所有文件的属性，多用于RPM软件包、Linux内核的initramfs文件等；
touch file1 file2 file3
echo file1 file2 file3 | cpio -ov > archive.cpio
-o 指定了输出
-v 用来打印归档文件列表

# 列出cpio归档文件的内容
cpio -it < archive.cpio
-i 指定输入
-t 表示列出归档文件的内容

# 从归档文件中提取文件
cpio -id < archive.cpio





# ****************************** #
# 6.4 用gzip压缩

# 删除源文件并且生成一个压缩文件filename.gz
gzip filename

# 删除源文件并生成filename的未压缩形式
gunzip filename.gz

# 列出压缩文件的属性信息
gzip -l test.txt.gz

# 从stdin读入并写出到stdout
cat file | gzip -c > file.gz

# --fast 或 --best 选项提供最低或最高的压缩比

# 使用 tar
tar -czvvf archive.tar.gz [FILES]
或者
tar -cavvf archive.tar.gz [FILES]

# 另一种方法，先创建归档文件，然后在压缩
# 归档
tar -cvvf archive.tar [FILES]
# 压缩
gzip archive.tar

# 多个文件需要压缩的时候
FILE_LIST='file1 file2 file3 file4 file5'
for f in $FILE_LIST
do
tar -rvf archive.tar $f
done
gzip archive.tar


# zcat 无需解压缩，直接读取gzip格式文件
$ ls
test.gz

$ zcat test.gz
A test file

# ls 
test.gz

# 指定压缩率 0~9 单调递增
gzip -9 test.img





# ****************************** #
# 6.5 用bzip压缩
# 压缩
$ bzip2 filename
$ ls 
filename.bz2

# 解压缩
$ bunzip2 filename.bz2
$ cat file | bzip2 -c > file.tar.bz2

# 结合 tar
# 方法一：
$ tar -cjvvf archive.tar.bz2 [FILES]
或者
$ tar -cavvf archive.tar.bz2 [FILES]

# 方法二：
$ tar -cvvf archive.tar.bz2 [FILES]
$ bzip2 archive.tar

# 提取压缩文件的内容
$ tar -xjvvf archive.tar.bz2 -C extract_directory
或者
$ tar -xavvf archive.tar.bz2 -C extract_directory

# 补充内容
# 保留输入文件
$ bunzip2 test.bz2 -k
$ ls 
test test.bz2

# 指定压缩率
$ bzip2 -9 test.img




# ****************************** #
# 6.6 用lzma压缩
$ lzma filename
$ ls
filename.lzma

$ unlzma filename.lzma

# -c 用于将输出指定到stdout
cat file | lzma -c > file.lzma

# 结合tar
# 方法一：
$ tar -cvvf --lzma archive.tar.lzma [FILES]
或者
$ tar -cavvf archive.tar.lzma [FILES]

# 方法二：
$ tar -cvvf archive.tar [FILES]
$ lzma archive.tar

# 补充内容：
# 提取lzma归档文件中的内容
$ tar -xvvf --lzma archive.tar.lzma -C extract_directory
或者
$ tar -xavvf archive.tar.lzma -C extract_directory

# 保留输入文件
$ lzma test.bz2 -k

# 指定压缩率
lzma -9 test.img




# ****************************** #
# 6.7 用zip归档和压缩
# 用法：
$ zip archive_name.zip [SOURCE FILES/DIRS]

# 对目录和文件进行递归操作, zip 不会删除源文件
szip -r archive.zip folder1 file2

# 提取文件
unzip file.zip

# 更新归档文件中的内容
zip file.zip -u newfile

# 从压缩归档文件中删除内容，使用-d
zip -d arc.zip file.txt

# 列出归档文件中的内容
unzip -l archive.zip




# ****************************** #
# 6.8 超高压缩率的squashfs文件系统
# 创建一个squashfs文件
mksquashfs SOURCES compressedfs.squashfs

# 挂载 squashfs 文件
mkdir /mnt/squash
mount -o loop compressedfs.squashfs /mnt/squash


# 创建时，排除一些文件
sudo mksquashfs /etc test.squashfs -e /etc/passwd /etc/shadow

# 先写入文件，然后排除
cat excludelist
# result
/etc/passwd
/etc/shadow

sudo mksquashfs /etc test.squashfs -ef excludelist




# ****************************** #
# 6.9 加密工具与散列
# crypt
$ crypt <input_file> output_file
$ crypt PASSPHRASE < input_file > encrypted_file
$ crypt PASSPARASE -d < encrypted_file > output_file

# gpg
gpg -c filename
gpg filename.gpg

# Base64
base64 filename > outputfile
或者
cat file | base64 > outputfile

base64 -d file > outputfile
或者
cat base64_file | base64 -d > outputfile


# md5sum 与 sha1sum
md5sum file

sha1sum file

# shadowlike散列(salted散列)
可以查看 /etc/shadow
openssl passwd -l -salt SALT_STRING PSASSWORD





# ****************************** #
# 6.10 用raync 备份系统快照
# 将源目录复制到目的端
rsync -av source_path destination_path

# 将数据备份到远程服务器或主机
rsync -av source_dir username@host:PATH

# 将远程主句上的数据恢复到本地主机
# rsync 使用 SSH连接远程主机，用user@host这种形式设定远程主机的地址
rsync -av username@host:PATH destination

# 传输数据的时候，对数据进行压缩
-z


# 下面两个是不同的, 前者复制目录的所有内容，后者只复制目录
rsync -av /home/test/ /home/backups
rsync -av /home/test /home/backups


# 下面两个也是不同的，前者复制到目录backups中，后者会先创建backups，然后将内容复制到此目录中
rsync -av /home/test /home/backups/
rsync -av /home/test /home/backups

# 归档时排除部分文件
rsync -avz /home/code/some_code /mnt/disk/backup/code --exclude "*.txt"

# 先将须排除的文件列表存放在文件中
使用 --exclude-from FILEPATH


# 目的端和源端，rsync默认不会删除那些在源端已不存在的文件，如果要删除，要使用 rsync 的 --delete
rsync -avz SOURCE DESTINATION --delete

# 定期调度备份
crontab -e
添加这么一行：
0 */10 * * * rsync -avz /home/code user@IP_ADDRESS:/home/backups





# ****************************** #
# 6.11 用Git备份版本控制















































