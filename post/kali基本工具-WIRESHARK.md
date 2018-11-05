---
title: WIRESHARK初识
date: 2016-04-11 08:48:52
tags: ['kali第五章','基本工具']
toc: true
categories: technology

---
### 0x00 WIRESHARK简介

wireshark前称Ethereal，是一个网络封包分析软件。网络封包分析软件的功能是撷取网络封包，并尽可能显示出最为详细的网络封包资料。Wireshark使用WinPCAP作为接口，直接与网卡进行数据报文交换(---百度百科)作为一款强大的抓包嗅探和协议分析工具，熟练的掌握它是安全专家必备技能！

wireshark本身只是对网络流量进行分析而不会去抓包，wireshark下的抓包组件引擎主要有两个:
* linux-Libpcap9
* windows-Winpcap10

衡量一个网络分析工具的强大与否最重要的一个参数指标就是它的解码能力，而wireshark在主流的分析软件中的解码能力是首屈一指的！

---
### 0x01 WIRESHARK的基本使用方法

wireshark是kali的十大安全工具之一，所以在kali2.0下我们很容易的就能找到她了！

* 指定抓包网卡
   在start的下拉框下指定抓取哪个网卡的进入流量，同样也可以选择interface list指定使用哪块网卡！
* interface list下的options：
 * 可以看到默认打钩的那一项[Use promiscuous mode on all interfaces](对所有的网卡使用混杂模式):抓取哪些经过我的网卡的但是并不是发送给我的数据包，不勾选则是不会抓取除了我本地网卡绑定的IP之外的数据包的！但如果你想了解下你所在的网络里的所有的机器传输数据的情况则必须选择混杂模式！
 * Cpature Filter(抓包筛选器):为了减少混杂模式下所抓取的大量数据包对分析所产生的影响，我们可以过滤掉那些我并不想要抓取的数据包！点击Capture Filter选则格式抓取指定类型的数据包！

---
### 0x02 对抓取的数据进行保存
菜单栏>File>Save!只要是对数据保存的格式的选择，建议选择兼容性最好的Wireshark/tcpdumo/-pcap格式！最后好可以选择gzip对数据包进行压缩！以后便可以将其提取出来进行分析了！

---
### 0x03 WIRESHRK界面初识
Edit->Preferences(首选项):界面布局，对wireshark进行主题，颜色，字体等选择！

---
### 0x04 WIRESHARK筛选器
 * _抓包筛选器_(Display Filters)
 * _显示筛选器_(Capture Filters)

---
### 0x05 常见协议包

* _Arp:_
* _lcmp:_
* _TCP:_
* _UDP:_
* _DNS:_
* _HTTP:_
* _FTP:_


