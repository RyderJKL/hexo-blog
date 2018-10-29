---
title: SQL简单语句
date: 2015-05-17
tags: ['Web程序设计']
toc: true
categories: technology

---
### 0x00 select的使用

语法： 

__{ Select  [Top(数值)] 字段列表 *From 表 [Where 条件 ][Order By 字段]       [Group 字段] }__           

其中: 
* order by:按字段排序  
* group by 按字段求和    

##### 选取全部数据    

```
Select *From table
```

###### 选取指定字段的数据

```
Select name，sex，age From table  
```

##### 只选取前3条数据

```
Select Top *From table  
//Select Top（3）From table Where name  
```

##### 用原表中的字段产生派生字段  

```
Select name，（submit_date+365）=new_date From table  
```

##### 根据条件选取  

```
Select *From table where name='曹操'  
```

##### 关键字查询

```
Select *From table Where name like'%嘲%'  
//Select *From name like'李%'    
```

##### 查询结果排序  

```
Select *From table Order By name ASC(升序)||DESC(降序)
```

---
### 0x01 insert的使用
麻痹的insert 不能单独与where结合使用这是无意义的！！fuck fuck fuck！！

语法：

__{ Insert Into 表（字段1，字段2，。。。。）Values（字段1的值，字段2的值,...）}__

##### 增加一条完整信息  

```
Insert Into table （name，sex，age，number，submit_data）Values（'蒙蒙'，'男'，'6'，'174855893'，#11/1/2013#）
```

---
### 0x02 update的使用

语法：

__{ Update 表 Set 字段1=字段1值，字段2=字段2值，……[Where 条件] }__

##### 修改用户电话和email

```
Update table Set tel='33342',email='234@qq.com' Where name='jijiang' 
```

##### 将所有人的年龄增加10

```
Update table Set age=age+104
```

---
### 0x03 Delete的使用

语法：

__{ Delete From 表 [Where 条件] }__

##### 删除一个表

```
Delete From table
```


##### 按条件删除

```
Delete From table Where name=‘曹超';
```

---
### 0x04 like模糊查询

“-”“[]”(特别注意只有 char varchar text 类型的数据才能使用like运算符和通配符）

##### like相当于=

```
select from table where name like '计算机'        
``` 

#####  like相当于<>

```
select from table where name not like '计算机' 
```                 

---
### 0x05 通配符%

```
select name,scout,ctest
from course
where chame like '计算机%'  //查询以course表中差么字段以计算机开头的所有开头匹配查询
like '%计算机'   //结尾匹配查询
like '%中间匹配%' //中间匹配查询
like  '计算机%基础'   //使用通配符%查询以“计算机”开头“基础”结束的所有信息
```

---
### 0x06 通配符-
与like类似 只是在确定字段个数但不确定某个或几个字时使用:

#####  查询包含以计算机开头的六个字的所有课程       

```
select  cname，scount,ctest
from couse
where  cname like  ‘计算机---'
and  not  cname like  '计算机--'
```

---
### 0x07 通配符[ ]
用于查询指定一系列的字符，只有满足这些字符其中之一且出现在[ ]的位置时，满足查询条件

##### 查询以不以”计“或”生“字开头的所有课程名称
```
select  cname,scount,ctest
from course
where cname like '[^计生]%'
order by cname desc
```                           

---
### 0x08 转义字符 escape   

```
like '%m%'  escape 'm'         
```

用escape定义了转义字符 m 所以第二个%被作为”百分号“而不再作为sql的关键字。                             


