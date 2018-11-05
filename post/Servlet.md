---
title: Servlet
date: 2016-07-25
tags: ['Java-J2EE']
toc: true
categories: technology


---
### 0x01 Servlet简介

---
#### CGI
CGI(Common Gateway Interface)通用网关接口。是一种根据请求信息动态产生回应内容的技术。通过CGI，Web服务器可以将根据请求不同启动不同的外部程序，并将请求内容转发给该程序，在程序执行结束后，将执行结果作为回应返回给客户端。也因此，将会产生大量的进程，从而占用许多资源。此外，CGI不可移植。显然在大数据，云计算技术等互联网的新生代下，该技术日显落寞。

---
#### Servlet
Servlet(Servlet Applet),全称Java Servlet，是用Java编写的服务器端程序，其主要功能在于交互式地浏览和修改数据，生成动态Web内容。与CGI不同的是，Servlet对每个请求都是单独启动一个线程，而不是进程。这种处理方式大幅度地降低了系统里的进程数量，提高了系统的并发处理能力。另外因为Java Servlet是运行在虚拟机之上的，也因此了解决了跨平台问题。同样没有Servlet的出现，也没有互联网的今天。

Servlet其过程分为如下四个:

* 客户端发送请求至服务器端;
* 服务器端将请求信息发送至Servlet；
* Servlet、生成响应内容并将其传给服务器；
* 服务器将响应返回给客户端。

但是使用Servlet来进行编写程序并不容易，需要实现的方法太多，所以编写Servlet时直接继承HttpServlet，并覆盖需要的方式即可。一般只覆盖**doGet()**和**doPost()**方法即可。


###### doGet()
当form中的method属性设为"GET"时，浏览器就会以GET方式提交表单数据，表单会根据Action中的设置判断将数据提交到什么
地方，Servlet或者JSP。

使用GET的方式进行表单的提交，浏览器会把表单的内容组织成一个字符串，变量之间用“&”进行连接，然后以Servlet路径加“？”加查询字符串的形式获取服务器内容。使用这种方式并不安全，因为所有需要传输的数据会显示在浏览器的地址栏上。

###### doPost()
将FORM中的methods属性设置为“POST”，浏览器就会以POST的方式提交表单内容。在POST提交表单时，表单的内容不会在浏览器中显示，因此使用POST提交方式比较安全，适用于提交一些密码等信息。

此外Servlet可以通过**HttpServletRequest**特性的getPraramter(String parame)__是属性来获取param对应的参数 

---
### 0x2 Servlet路径部署
JavaEE web规范了服务器搜索Servlet类的路径:WEB-INF/calsses以及WEB-INF/lib下所有的jar文件(jar包)。

比如写好了一个LoginServlet.java的Servlet文件，那么便需要将LoginServlet.java编译后文件LoginServlet.class文件放到WEB-INF/classs/com/jack/loginServlet/中

当然，如果使用MyEclipse的话只需重新部署项目就可以了，选择好web项目的本地存放路劲，其它的都会自动配置的。

只需要再__web.xml__项目部署文件中配置好Servlet的请求匹配路径就好了。

比如有两个页面index.jsp和LoginServlet.java页面。它们的关系是index.jsp中的form表单会将数据提交给loginServlet.java。但是不会直接使用跳转，而是通过web.xml的配置文件来过渡(映射)的。

index.jsp--->web.xml--->loginServlet.java

index.jsp文件

```
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>登录</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
</head>

<body>
	<%
		if (request.getAttribute("Error") != null) {
			// 有错误，要进行打印输出
			List all = (List) request.getAttribute("Error");
			Iterator iter = all.iterator();
			while (iter.hasNext()) {
	%>
	<p><%=iter.next()%></p> <%
 	}
 	}
 %>
<form action="loginServlet" method="post">
	<div>
		<table>
			<tr>
				<td><strong>登录名:</strong></td><td><input type="text" name="username"></td>
			</tr>
			<tr>
				<td><strong>密码:</strong></td><td><input type="password" name="password"></td>
			</tr>
			<tr><td><input type="submit" name="submit" value="提交"></td>
			<td><input type="reset" name="reset" value="重置"></td></tr>
		</table>
	</div>
</form>
</body>
</html>
```

web.xml配置:

```
  <servlet>
    <description>控制用户发送来的请求</description>
    <display-name>LoginServlet</display-name>
    <servlet-name>LoginServlet</servlet-name>
    <servlet-class>com.jack.servlet.LoginServlet</servlet-class>
  </servlet>

  <servlet-mapping>
    <servlet-name>LoginServlet</servlet-name>
    <url-pattern>/loginServlet</url-pattern>
 </servlet-mapping>	
  <welcome-file-list>
    <welcome-file>index.jsp</welcome-file>
  </welcome-file-list>
```

LoginServlet.java文件

```
package com.jack.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jack.factory.DAOFactory;
import com.jack.pojo.Login;

public class LoginServlet extends HttpServlet {

	/**
	 * Constructor of the object.
	 */
	public LoginServlet() {
		super();
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

	/**
	 * The doGet method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doPost(request, response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 * 
	 * This method is called when a form has its tag value method equals to
	 * post.
	 * 
	 * @param request
	 *            the request send by the client to the server
	 * @param response
	 *            the response send by the server to the client
	 * @throws ServletException
	 *             if an error occurred
	 * @throws IOException
	 *             if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List errors = new ArrayList();
		String path = "../index.jsp";
		String name = request.getParameter("username");
		String pwd = request.getParameter("pwd");
		Login lg = new Login();
		lg.setUsername(name);
		lg.setPassword(pwd);
		lg.setErrors(errors);
		boolean isValid = lg.isInvalidate();
		System.out.println("判断输入格式是否合法" + isValid);
		// 如果输入合法，再进行数据库端的验证
		if (isValid) {
			if (DAOFactory.getLoginDAOInstance().isLogin(lg)) {
				System.out.println("数据库匹配验证");
				path = "../success.jsp";
			} else {
				errors.add("用户名密码不对!");
			}
		}
		request.setAttribute("Error", errors);
		request.setAttribute("Lg", lg);
		System.out.println("<html>");

	}

	/**
	 * Initialization of the servlet. <br>
	 * 
	 * @throws ServletException
	 *             if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
```

如上创建了一个index.jsp页面，form表单会将数据提交到路径为action="loginServlet"中的Servlet程序(实际上这个程序就是LoginServlet.class(由LoginServlet.java编译后的文件))，而loginServlet是实际上不存在的，它只是一个别名或者说一虚拟的url路径而已。

值得注意的是web.xml中<url-pattern>/loginServlet</url-pattern>和index.jsp中的action="loginServlet"必须一致。

然后web.xml会将/loginServlet映射为com.jack.servlet.LoginServlet页面。


---
### 0x03 Servlet转发
Servlet的请求转发有三种形式，主要是通过HttpServletRequest和HttpServletResponse对象来实现的。

Java代码:

```
public void service(HttpServletRequest request,HttpServletResponse response) throws ServletException,IOException {
   request.getRequestDispathcer("/url").include(request,response);
   request.getRequestDispathcer("/url").forward(request,response);
   request.sendRedirect("/url");
}
```

它们的区别是:
include是把另一个servlet/jsp处理过后的内容拿过来与本身的servlet内容一起输出；forward是把请求的内容转发到另一个servlet/jsp中。

include是把被人包含进来，forward则是丢掉自己。而sendRedict则是单纯的重定向。

---
### 0x04 ServletContext
ServletContext是Servlet与Servlet容器之间的直接通信接口，每个web应用有唯一的一个servletConetxt对象。同一个web应用的所有servlet对象共享一个servletContext，sevlet对象可以通过它来访问容器中的各种资源。

----
#### 获取内存共享数据的方法
###### setAttribute
setAttribute(String name,java.lang.Object object):把一个java对象和属性名绑定，并存放到SevletContext中，参数name指定属性名，参数Object表示共享数据。

###### setAttribute(String name):根据参数给定的属性名，返回一个object类型的对象

###### getAttributeNames():返回一个Enumeration对象，该对象包含了所有存放在SetvletContext中的属性名。

###### removetAttribute(String name):根据参数指定属性名，从ServletContext对象中删除匹配的属性。


#### servletContext对象获得的几种方法
Javax.servlet.HttpSession.getServletContext()
Javax.servlet.jsp.PageContext.getServletContext()
Javax.servlet.ServletConfig.getServletContext()


