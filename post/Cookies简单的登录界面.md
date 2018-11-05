---
title: Cookies简单的登录界面
date: 2015-05-30
tags: ['Web程序设计']
toc: true
categories: technology

---
### 0x00 登陆页面

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OleDb;
public partial class denglu : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string user = txt_name.Text.Trim();
        string pass = txt_pass.Text.Trim();
        OleDbConnection cs =new OleDbConnection("Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=student;Data Source=QTOS-20130815OU\\SQLEXPRESS");
        cs.Open();
        string cx = "select * from student1 where name='" + user + "'and passwd='" + pass + "'";
        OleDbCommand cx1 = new OleDbCommand(cx, cs);
        OleDbDataAdapter adp = new OleDbDataAdapter(cx1);
        DataSet da = new DataSet();
        adp.Fill(da);
        if (da.Tables[0].Rows.Count > 0)
        {
            Response.Cookies["user"].Value = user;
            Response.Cookies["user"].Expires = System.DateTime.Now.AddHours(9);
            Response.Redirect("denglu1.aspx");
        }
        else
        {
            Response.Write("该用户不存在");
        }
    }
}
```

---
### 0x01 接受页面

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class denglu1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Cookies["user"] == null)
        {
            Response.Redirect("denglu.aspx");
        }

    }
}
```


