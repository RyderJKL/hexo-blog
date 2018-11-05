---
title: Java(8)异常处理
date: 2016-07-20
tags: ['Java基础']
toc: true
categories: technology

---
### 0x1 Java异常处理机制
Java中异常处理机制，可以使程序发生异常的时候__抛出(throw)__代表当前状况的对象，逐层退出方法调用，直到遇到__异常处理器(Exception Handler)__，\异常处理器可以__捕捉(catch)__到异常对象，并根据对象来决定下一步的行动。

其中try负者监视程序块，catch代表所要捕获的异常的类型，并捕获相应的类型及其衍生类。catch可以有多个参数，以对应try可能出现的多个异常。最后，不论异常是否发生，finally中的程序都会被执行。

比如对数据库连接异常的处理

```
public static void main(String[] args) {
//		 TODO Auto-generated method stub
		Connection conn=null;
		Statement stmt=null;
		ResultSet rs=null;
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
			 rs=((java.sql.Statement) stmt).executeQuery("select * from Student");
			while(rs.next()){
				System.out .println(rs);
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			try {
				rs.close();
				stmt.close();
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
              }
			}
```


