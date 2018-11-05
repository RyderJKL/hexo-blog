---
title: 使用GrideView控件
date: 2015-05-17
tags: ['Web程序设计']
toc: true
categories: technology

---
### 0x00 数据绑定

```
DataSet ds = new DataSet();
DB sq = new DB();
string sql = "select *from table_2";
ds = sq.getdata(sql);
//对grideview进行默认的降序排序
ds.Tables[0].DefaultView.Sort = strcmd;
//对grideview进行数据绑定
GridView1.DataSource = ds.Tables[0].DefaultView;
GridView1.DataBind();
```

---
### 0x01 编辑

```
protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView1.EditIndex = e.NewEditIndex;
        bangdata();
    }
```

---
### 0x02 取消

```
 protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView1.EditIndex = -1;
    
    }
```

---
### 0x03 删除

```
protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //绑定关键字
        string str_id = GridView1.DataKeys[e.RowIndex].Value.ToString();

        string str_cmd = "delete from Table_2 where id=" + str_id;
        DB coon = new DB();
        coon.excutesql(str_cmd);
    }
```

---
### 0x04 更新

在使用GridView控件进行数据更新时可以为数据源设置DataKeyNames关键字段，在GridView属性，数据的DataKeyNames中添加以逗隔开的字段关键子。

```
protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        //绑定关键字
        string str_id = GridView1.DataKeys[e.RowIndex].Value.ToString();
        //通过强制转换获取控件里的值，方法1：
        string str_name = ((TextBox)GridView1.Rows[e.RowIndex].Cells[1].Controls[0]).Text.Trim();
        string pass_word = ((TextBox)GridView1.Rows[e.RowIndex].Cells[2].Controls[0]).Text.Trim();
        string str_jiguan = ((TextBox)GridView1.Rows[e.RowIndex].Cells[3].Controls[0]).Text.Trim();
        string str_age = ((TextBox)GridView1.Rows[e.RowIndex].Cells[4].Controls[0]).Text.Trim();
        string str_sex = ((TextBox)GridView1.Rows[e.RowIndex].Cells[5].Controls[0]).Text.Trim();

/*方法2：通过强制转换获取控件里的值
string str_sex = ((DropDownList)GridView1.Rows[e.RowIndex].FindControl("DropDownList1")).SelectedValue.ToString();
)*/
        string str_email = ((TextBox)GridView1.Rows[e.RowIndex].Cells[6].Controls[0]).Text.Trim();
        string str_cmd = "update Table_2 set name='" + str_name + "',password='"+pass_word+"',jiguan='" + str_jiguan + "',age='"+str_age+"',sex='"+str_sex+"',email='"+str_email+"' where id="+str_id;
        DB coon = new DB();
        coon.excutesql(str_cmd);
        GridView1.EditIndex = -1;
        bangdata();
  
    }
```

---
### 0x04 分页

```
protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        bangdata();

    }
```

---
### 0x05 排序

```
protected void GridView1_Sorting(object sender, GridViewSortEventArgs e)
    {
        strcmd = e.SortExpression;
        bangdata();
    }
```


