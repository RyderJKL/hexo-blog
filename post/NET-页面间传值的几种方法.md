---
title: NET 页面间传值的几种方法
date: 2015-07-08
tags: ['Web程序设计']
toc: true
categories: technology

---
### 0x00 QueryString传值
1. 这是最简单的传值方式，但缺点是传的值会显示在浏览器的地址栏中且不能传递对象，只适用于传递简单的且安全性要求不高的整数值。

新建一个WEB项目，添加一个页面命名为Test1，在页面中添加一个Button命名为btnLogin，再添加两个TextBox分别命名为tbxUserName和tbxPassWord，添加Buttond的Click()事件：

```
private void btnLogin_Click (object sender, System.EventArgs e)
    {

    string url=" Test2.aspx?UserName=" +tbxUserName.Text + "&Password=”+tbxPassWord.Text+””;
    Response.Redirect(url);
}
```

添加另一个页面命名为Test2，在页面添加两个Lable分别命名为labUserName和labPassWord，添加页面的Load()事件：

```
private void Page_Load (object sender, System.EventArgs e)

{

    labUserName.Text=Request.QueryString["UserName"];

    labPassWord.Text=Request.QueryString["Password"];

}
```

把Test1设为起始页，运行项目在Test1页面的文本框中输入值后点击按钮，就可以在Test2页面中显Test1页面输入的结果。

 

---
### 0x01 Server.Transfer传值
这种方式避免了要传递的值显示在浏览器的地址栏中，但是比较麻烦。

同样新建一个WEB项目，添加两个页面分别命名为Test1和Test2，在Test1页面中添加一个Button命名为btnLogin，再添加两个TextBox分别命名为tbxUserName和tbxPassWord，在Test2页面添加两个Lable分别命名为labUserName和labPassWord，为Test1添加过程返回tbxUserName和tbxPassWord的值并添加btnLogin的Click()事件：

```
public string UserName

{
    get
    {
        return tbxUserName.Text;
    }
}

public string Password
{
    get
    {
        return tbxPassWord.Text;
    }

}

private void btnLogin_Click (object sender, System.EventArgs e)
{
    Server.Transfer("Test2.aspx");
}
```

添加Test2页面的Load()事件：

```
private void Page_Load (object sender, System.EventArgs e)
{
    Test1 t1; //创建原始窗体的实例
    t1=( Test1)Context.Handler; //获得实例化的句柄
    labUserName.Text= t1.UserName;
    labPassWord.Text= t1.Password;
}
```

把Test1设为起始页，运行项目在Test1页面的文本框中输入值后点击按钮，就可以在Test2页面中显Test1页面输入的结果。

 
---
### 0x02 Cookie对象变量
Cookie是针对每一个用户而言的，是存放在客户端的 ，Cookie的使用要配合ASP.NET内置对象Request来使用。

新建一个WEB项目，添加两个页面分别命名为Test1和Test2，在Test1页面中添加一个Button命名为btnLogin，再添加两个TextBox分别命名为tbxUserName和tbxPassWord，在Test2页面添加两个Lable分别命名为labUserName和labPassWord，为Test1添加Buttond的Click()事件：

```
private void btnLogin_Click (object sender, System.EventArgs e)
{
    HttpCookie cookie_UserName = new HttpCookie("UserName");
    HttpCookie cookie_PassWord = new HttpCookie("PassWord ");
    cookie_ UserName.Value = tbxUserName.Text;
    cookie_ PassWord.Value = tbxPassWord.Text;
    Response.AppendCookie(cookie_ UserName);
    Response.AppendCookie(cookie_ PassWord);
    Server.Transfer("Test2.aspx");
}
```

添加Test2页面的Load()事件：

```
private void Page_Load (object sender, System.EventArgs e)
{
    labUserName.Text = Request.Cookies["UserName"].Value.ToString();
    labPassWord.Text = Request.Cookies["PassWord "].Value.ToString();
}
```

把Test1设为起始页，运行项目在Test1页面的文本框中输入值后点击按钮，就可以在Test2页面中显Test1页面输入的结果。
 

---
### 0x03 Session对象变量
 Session也是针对每一个用户而言的，但它是存放在服务器端的 ，Session不仅可以把值传递到下一个页面，还可以交叉传递到多个页面，直至把Session变量的值removed 后，变量才会消失。

新建一个WEB项目，添加两个页面分别命名为Test1和Test2，在Test1页面中添加一个Button命名为btnLogin，再添加两个TextBox分别命名为tbxUserName和tbxPassWord，在Test2页面添加两个Lable分别命名为labUserName和labPassWord，为Test1添加Buttond的Click()事件：

```
private void btnLogin_Click (object sender, System.EventArgs e)
{
    Session["UserName"]=tbxUserName.Text;
    Session["PassWord"]=tbxPassWord.Text;
    Response.Redirect("Test2.aspx");
}
```

添加Test2页面的Load()事件：

```
private void Page_Load (object sender, System.EventArgs e)
{
    labUserName.Text=Session["UserName"].ToString();
    labPassWord.Text=Session["Password"].ToString();
    Session.Remove("UserName"); //清除Session
    Session.Remove("PassWord"); //清除Session
}
```

把Test1设为起始页，运行项目在Test1页面的文本框中输入值后点击按钮，就可以在Test2页面中显Test1页面输入的结果。

 

---
### 0x04 Application对象变量：
Application对象的作用范围是整个全局，也就是说对所有用户都有效。其常用的方法用Lock和UnLock，例如：

新建一个WEB项目，添加两个页面分别命名为Test1和Test2，在Test1页面中添加一个Button命名为btnLogin，再添加两个TextBox分别命名为tbxUserName和tbxPassWord，在Test2页面添加两个Lable分别命名为labUserName和labPassWord，为Test1添加Buttond的Click()事件：

```
private void btnLogin_Click (object sender, System.EventArgs e)
{
    Application["UserName"] = tbxUserName.Text;
    Application["PassWord "] = tbxPassWord.Text;
    Server.Transfer("Test2.aspx");
}
```

添加Test2页面的Load()事件：

```
private void Page_Load (object sender, System.EventArgs e)
{
    Application.Lock();
    labUserName. Text = Application["UserName"].ToString();
    labPassWord. Text = Application["PassWord "].ToString();
    Application.UnLock();
}
```


