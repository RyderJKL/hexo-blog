---
title: 使用DataList控件
date: 2015-05-30
tags: ['Web程序设计']
toc: true
categories: technology

---
### 0x00 DataList控件

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class datalist : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bind();
        }
    }
    protected void bind()
    {
        string str_view = "select * from book ";
        database db = new database();
        DataSet ds = db.viewdatabase(str_view);
        DataList1.DataSource = ds.Tables[0].DefaultView;
        DataList1.DataBind();
    }
    protected void DataList1_CancelCommand(object source, DataListCommandEventArgs e)
    {
        DataList1.EditItemIndex = -1;
        bind();
    }
    protected void DataList1_DeleteCommand(object source, DataListCommandEventArgs e)
    {
        string str_id = DataList1.DataKeys[e.Item.ItemIndex].ToString();
        string str_del = "delete from book where id=" + str_id;
        database db = new database();
        db.cmddatabase(str_del);
        bind();
    }
    protected void DataList1_EditCommand(object source, DataListCommandEventArgs e)
    {
        DataList1.EditItemIndex = e.Item.ItemIndex;
        bind();
    }
    protected void DataList1_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "more")
        {
            DataList1.SelectedIndex = e.Item.ItemIndex;
            bind();
        }
        if (e.CommandName == "back")
        {
            DataList1.SelectedIndex = -1;
            bind();
        }
    }
    protected void DataList1_UpdateCommand(object source, DataListCommandEventArgs e)
    {
        string str_up = "";
        string str_id = DataList1.DataKeys[e.Item.ItemIndex].ToString();
        string bookname = ((TextBox)e.Item.FindControl("txt_book")).Text.Trim();
        string price = ((TextBox)e.Item.FindControl("txt_price")).Text.Trim();
        string author = ((TextBox)e.Item.FindControl("txt_author")).Text.Trim();
        string copyright = ((TextBox)e.Item.FindControl("txt_copy")).Text.Trim();
        str_up = "update book set bookname='"+bookname+"',price='"+price+"',author='"+author+"',copyright='"+copyright+"' where id=" + str_id;
        database db = new database();
        db.cmddatabase(str_up);
        DataList1.EditItemIndex = -1;
        bind();
    }
}
```

---
### 0x01 datalist 数据显示自动换行
在前台添加代码

```
 <style type="text/css">
        #form1
        {
            word-break:break-all ;word-wrap: break-word;
             display:block ;
        }  
  </style>
```


