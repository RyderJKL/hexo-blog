---
title: Java-Java连接MSSQL数据库
date: 2016-07-23
tags: ['Java应用']
toc: true
categories: technology

---
### 0x01 
__Connection对象__代表Java与数据库的连接。

连接完成，如果要执行SQ的话，必须建立__Statement对象__，它会执行SQL指令并返回执行结果。可以使用Connection的__createStatement()__方法来建立Statement对象。

建立Statement对象之后，我们可以使用__executeUpdate()__\、__executeQuery()__等方法来执行 SQL，executeUpdate()主要执行更新等可以改变数据库内容有关的操作。

executeQuery()方法则是用于SELECT等查询数据库的SQL，executeUpdate()与 executeQuery()都会传回__ResultSet对象__，代表变更或查询的结果，查询的结果会是一笔一笔的数据。可以使用__next()__方法来移动至下一笔数据，它会传回 true 或 false表示是否有下一笔资料，接着可以使用__getXXX()__来取得资料，例如__getString()__\、__getFloat()__\、__getDouble()__等方法，分别取得相对应的字段型态数据，getXXX()方法都提供有依字段名称取得数据，或是依字段顺序取得数据的方法，



```
package com.jack.test;
//import java.sql.*
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.ResultSet;
public class TestMain {

	public static void main(String[] args) {
//		 TODO Auto-generated method stub
		Connection conn=null;//连接对象
		Statement stmt=null;//SQL指令集
		ResultSet rs=null;//查询结果集
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			String url="jdbc:sqlserver://192.168.0.149:1433;DatabaseName=baiYi";
			//test为你的数据库的名称  
			String user="sa";
			String password="123";
			conn=DriverManager.getConnection(url,user,password);
			 stmt=conn.createStatement();
			String query="";
			stmt.executeUpdate(query);
			 rs=stmt.executeQuery("select * from Student");
			while(rs.next()){
				System.out .println(rs);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
            System.out.println("找不到驱动程序！");
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			try {
				rs.close();//关闭结果集
				stmt.close();//关闭指令集
				conn.close();//关闭连接
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
              }
			}

}
```


