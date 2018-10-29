---
title: Python标准库(6)-subprocess包
date: 2016-05-27 22:19
tags: ['Python标准库']
toc: true
categories: technology

---
### 0x00 
subprocess包主要是 __执行外部命令和程序__ 某种意义上，subprocess的功能与shell类似。此外subprocess还提供了管理标准流(standard stream)和管道(pipe)的工具，以便进行进程间的通信。

#### subprocess.call()函数
可以利用subprocess.call函数来呼叫shell执行我们想执行的命令:

```
import subprocesssubprocess.call(["ls", "-l"])subprocess.call("ls -l", shell=True)
```

我们也可以将程序名和参数一起放在一个表中传递给subproc.call()

```
import subprocess
rc = subprocess.call([''ls", "-l"])
```

两种方式结果一样的，只是第一种方法会更安全。

subprocess.call()函数的父进程会等待子进程的完成，返回的退出信息(returncode)。于此 函数相似的函数还有 __subprocess.check_call()__ 子进程完成以后返回0，并检查退出信息，若是returncode不为0则举出错误，可以使用 `try...except...` 来检查错误;同样 __subprocess.check_output()__ 也会等待子进程完成并返回子进程向标准输出输出的结果。检查退出信息。

#### Popen()
实际上以上三个函数都是基于 __Popen()__ 的封装(wrapper)，封装的目的在于我们能更加容易的使用子进程。但是若想更加个性化的使用子进程时，就要使用Popen类来创建对象一代表子进程。

与上面的封装不同，Popen对象创建以后，主程序不会自动等待子进程完成，需调用对象的wait()方法后，父进程才会等待(即是阻塞 block)。

```
import subprocesschild = subprocess.Popen(["ping", "-c", "5", "www.baidu.com"])
child.wait() #若是不调用wait()方法子，将不回看到子进程的运行
print("parent process")
```

此外，也可以在父进程中对子进程进行其它操作，比如:

* child.poll():检查子进程的状态
* child.kill():终止子进程
* child.send_signal():向子进程发送信号
* child.terminate():终止子进程
* child.pid():子进程的pid

---
### 0x01 子进程的文本流控制
对于子进程的标准输入，标准输出和标准错误可以使用如下属性表示:

* child.stdin
* child.stdout
* child.stdeer

可以子啊Popen()建立子进程的时候改变标准输入，标准输出和标准错误，并利用 __subprocess.PIPE__ 将多个的子进程的输入和输出连接在一起构成管道(pipe):

```
import subprocesschild = subprocess.Popen(["ls", "-l"], stdout=subprocess.PIPE)
child1 = subprocess.Popen(["wc"], stdin=child.stdout, stdout=subprocess.PIPE)
out = child1.communicate()
print(out)
```

subprocess.PIPE实际上为文本提供一个缓冲区。child的stdout将文本输出到缓冲区，随后child1的stdin从该PIPE中将文本读取。child1的输出文本也被存放在PIPE中，直到communicate()方法从PIPE中读取出PIPE中的文本。

communicate()是Popen对象的一个方法，该方法会阻塞父进程，直到子进程完成。

```
import subprocess
child = subprocess.Popen(["cat"], stdin=subprocess.PIPE)
child.communicate("chen")
```

启动子进程后，cat会等待输入，直到我们用communicate()输入"chen".

[本文来自](http://www.cnblogs.com/vamei/archive/2012/09/23/2698014.)


