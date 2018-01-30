Chapter5 网站下载
# 5.2 网站下载
# wget 的用法

wget URL

wget URL1 URL2 URL3

# 依据 URL 用wget 下载文件
wget ftp://example_domain.com/somefile.img

# -O 指定输出文件名 ； -o 指定一个日志文件
wget ftp://example_domain.com/somefile.img -O dloaded_file.img -o log

# 设置重试次数
wget -t 5 URL

# 设置下载限速
wget --limit-rate 20k http://example.com/file.iso

# 设置下载配额
wget -Q 100m http://example.com/file1 http://example.com/file2

# 断电续传
wget -c URL

# 用cURL下载
curl http://slynux.org > index.html

# 复制或镜像这个网站
wget --mirror exampledomain.com
或者
wget -r -N -l DEPTH URL
-l 指定页面层级DEPTH，也就是向下遍历指定的页面级数

# 访问需要认证的http或ftp页面
wget --user username --password pass URL





# ****************************** #
# 5.3 以格式化纯文本形式下载网页
lynx -dump URL > webpage_as_text.txt
cat webpage_as_text.txt



# ****************************** #
# 5.4 cURL入门
# cURL通常将下载文件输出到stdout,将进度信息输出到stderr,要想避免进度信息，可以使用 --slient
curl URL --slient # 默认显示到终端

# -O用来下载数据写入文件
curl URL --slient -O

# -o用来将下载的数据写入指定名称的文件
curl URL --silent -o new_filename

# 显示进度信息
curl URL -o index.html --progress

# 断点续传
curl URL/file -C offset

# 断点计算 自动计算
curl -C URL

# 用cURL设置参照页字符串
curl --referer Referer_URL target_URL
例如：
curl --referer http://google.com http://slynux.org


# 用cURL设置cookie
curl URL --cookie "user=slynux;pass=hack"

# 将cookie另存为一个文件，使用 --cookie-jar
curl URL --cookie-jar cookie_file

# 用cURL设置用户代理字符串 （用于某些只能用IE访问的页面）
curl URL --user-agent "Mozilla/5.0"

# 通过cURL发送HTTP头部信息
curl -H "Host:www.slynux.org" -H "Accept-language: en" URL

# 限定cURL可占用的带宽
curl URL --limit-rate 20k

# 指定下载量
curl URL --max-filesize bytes

# 用cURL进行认证
curl -u username:password URL

curl -u username URL

# 只打印响应头部信息
curl -I URL




