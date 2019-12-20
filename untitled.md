## Mac 空格预览markdown插件
[插件地址](http://inkmarkapp.com/markdown-quick-look-plugin-mac-os-x/)
## 如何将应用安装到模拟器
1. 运行程序，找到对应的`.app`文件，并拷贝给使用方
2. 打开终端运行命令 `/Applications/Xcode.app/Contents/Developer/usr/bin/simctl install booted /Users/bourbonz/Desktop/ivwen.app` 后面是接收方文件存放位置。
3. 执行完后就能看到`app`安装到对方的模拟器上

## 使用`appledoc`生成文档
1.  `appledoc --project-name ProjectName --project-company CompanyName ./ `

## 什么是跨域，iOS要如何解决跨域
1. 跨域，指的是浏览器不能执行其他网站的脚本。它是由浏览器的同源策略造成的，<font color=red>是浏览器施加的安全限制</font>。
2. 距离说明：
地址 | 地址 | 解释
- | :-: | -
http://www.123.com/index.html | http://www.123.com/server.php |（非跨域）
http://www.123.com/index.html | http://www.456.com/server.php |（主域名不同:123/456，跨域）
http://abc.123.com/index.html | http://def.123.com/server.php |（子域名不同:abc/def，跨域）
http://www.123.com:8080/index.html | http://www.123.com:8081/server.php |（端口不同:8080/8081，跨域
http://www.123.com/index.html | https://www.123.com/server.php |（协议不同:http/https，跨域）

* 请注意：localhost和127.0.0.1虽然都指向本机，但也属于跨域。



