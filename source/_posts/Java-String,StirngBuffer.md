---
title: Java-String,StirngBuffer
date: 2016-07-22
tags: ['Java应用']
toc: true
categories: technology

---
### 0x1 String类
Java中，字符串被存储为String类对象，String类包含在java.lang包中，Java启动时会自动加载。

String类是不可变对象，程序员不能对已有的不可变对象进行更改。虽然String拥有可编辑字符串的功能，但这些功能是通过创建一个新的对象来实现的，不是对原有的对象进行直接编辑。

比如:

```
String s="hello world";
s=s.replace("world","universe");
System.out.println(s);
```

输出结果:hello universe

s.replace()的调用将会创建一个新字符串"hello universe"，并返回该对象的引用。赋值后，s将指向新的引用，若没有其它引用指向"hello world"，原来的字符串对象将被垃圾回收。


String是唯一一个不需要new关键字来创建对象的类。

此外：

```

public class TestString {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String s1="abc";
		//在字符串池中创建了一个对象
		String s2="abc";
		//字符串池中已经存在对象"abc",所以创建0个对象，累计创建一个对象
		System.out.println(s1==s2);
		//true，指向同一个对象(==比较的是引用所指向额对象在堆中的地址)
		System.out.println(s1.equals(s2));
		//true，内容相同
		
		String s3= new String("abc");
		//创建了两个对象，一个存放在字符串池中，一个存放在堆中
		//还有一个对象引用存放在栈中
		String s4= new String("abc");
		//字符串池中已经存在对象"abc"，所以只在堆中创建了一个对象
		
		System.out.println(s3==s4);
		//false,s3和s4栈地址不同，并且指向堆中不同的地址
		System.out.println(s3.equals(s4));
		//ture，内容相同	
			
	}

}
```

---
### 0x01 String中的常用方法

```
package com.jack.java;

public class testman {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String str="abcdefghi";
		String str2=str;
		String str1="hello world";
		System.out.println(str);
		System.out.println(str.length());//返回字符的长度
		System.out.println(str.charAt(2));//返回字符串中下标为2的字符
		System.out.println(str.substring(0,4));//返回下标[0,4)之间的字符串
		System.out.println(str.indexOf("def"));//返回def字符串的下标
		System.out.println(str.startsWith(" "));//判断str是否以空格开头
		System.out.println(str.endsWith("f"));//判断str是否以字符f结尾
		System.out.println(str.equals(str1));//比较str与str1的内容是否相等
		System.out.println(str.trim());//去掉str前后的空格，并返回新的字符串
		System.out.println(str.toUpperCase());//将str转换为大写，并返回新的字符串
		System.out.println(str.toLowerCase());//将str装换为小写，并返回新的字符串
		System.out.println(str.replace("abc","jklop"));//只能替换连续的字符串，并且原字符串对象依然存在，只是str引用的位置变了
		System.out.println(str2);
		
	}

}
```

---
### 0x2 StringBuffer
stringBuffer是一个可变对象，只能通过构造函数来建立，并通过__s.append()__方法对其追加元素。

当对其进行修改时不会像String那样重新建立新的对象，因此它的效率将会明显高于String。

```
String s1="abc";
		StringBuffer s2=new StringBuffer("abc");
		Runtime runtime=Runtime.getRuntime();
		long start =System.currentTimeMillis();
		long startFreeMemory=runtime.freeMemory();
		for(int i=0;i<10000;i++){
			s1+=i;
                        //s2.append("1");
		}
		long endFreeMemory=runtime.freeMemory();
		long end =System.currentTimeMillis();
		System.out.print("耗时:"+(end-start)+"ms,"+"内存消耗:"
		+(startFreeMemory-endFreeMemory)/1024/1024+"M");
 ```

输出:

```
耗时:549ms,内存消耗:1M
耗时:4ms,内存消耗:0M
```


