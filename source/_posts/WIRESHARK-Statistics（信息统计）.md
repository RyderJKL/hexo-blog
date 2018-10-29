---
title: WIRESHARK信息统计
date: 2016-04-11 08:48:52
tags: ['kali第五章','基本工具']
toc: true
categories: technology

---
### 0x00

* Endpoints:节点信息，包括tcp,udp的节点个数等！
* ProtocolHierarchy:了解当前所抓的数据都有哪些协议类型的包所占的百分比是多少。
* Conversation:判断哪个ip所占的宽带比例最多，是否被僵尸病毒入侵！

值得注意的是wireshark默认只是通过端口来对协议包进行判断的，即是80端口下它就会是tcp的协议包了，这显然是不准确的

* 解码方式Analyse—>Decode As:用来精确的分析数据包所属的协议类型！
* 专家信息:Analyse->Expert Info:
通过对专家系统给出的信息对网络中可能存在的问题进行判断，结论的正确与否完全取决于专家系统分析的结果是否准确！

---
### 0x01 WIRESHARK-实践
抓包对比nc，ncat加密与不加密流量对比：
虚拟机A: kali(192.168.137.13)；
虚拟机B: ubuntu(192.168.137.12)  {为方便操作，请同时将两个虚拟机的网卡改为hostonly模式【根据之前的设置Vmnet0就是honstonly模式的啦！】}

WIRESHARK的不足之处就是不适合大数据大流量的抓包分析处理！

---
### 0x02 其他更强大的抓包软件
* sniffer
* Cace/riverbed


