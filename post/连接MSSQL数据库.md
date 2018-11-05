---
title: Web.config数据库设置
date: 2015-05-30
tags: ['Web程序设计']
toc: true
categories: technology

---

### 0x00 Web.config数据库设置

```
< configuration >
< appSettings >
        <!-- 数据库设置Start -->
        <!-- Access or MsSql -->
        < add key =" DBType " value ="MsSql " />
        < add key =" MsSql " value ="Data Source=.;uid=sa;pwd=123;Initial Catalog=Library; " />
          <!-- <add key="MsSql" value="Data Source=PC-20131115XURX\SQLEXPRESS;Integrated Security=SSPI;Initial                                 Catalog=FrameWorknew;"/> -->
        <!-- <add key="MsSql" value="server=127.0.0.1;database=FrameWork;uid=sa;pwd=sa;"/> -->
        <!-- <add key="Access" value="\DataBase\Access\FrameWork.config"/>
          <!--add key="Oracle" value="Data Source=myhome;Persist Security Info=True;User ID=sa;Password=sa;Unicode=True"/>-->
        <!-- 数据库设置End -->
        <!-- 当前显示应用模组 0:显示所有应用 其它显示相关应用 -->
        < add key =" ApplicationID" value ="0 " />
        <!-- 用户在线过期时间 (分)默认30分 如果用户在当前设定的时间内没有任何操作,将会被系统自动退出 设为0则此功能无效(仅限于开发模式使用) -->
        < add key =" OnlineMinute" value ="600 " />
        <!-- 显示出错详细信息在用户页面(开发环境设置为True,在生产环境请设置为false) -->
        < add key =" DispError" value =" false " />
          </ appSettings >
          < connectionStrings >
            < add name =" BSPOWERConnectionString " connectionString =" Data Source=.;Intergrated Security=SSPI;Initial Catalog=MySQL;" providerName ="System.Data.sqlClient "/>
            < add name =" BSPOWERConnectionStrings " connectionString =" provider=sqlOleDb;Data Source=.;database=MySQL;uid=sa;pwd=123;" providerName ="System.Data.OleDb "/>
          </ connectionStrings >
< system.web >
< compilation debug =" false" targetFramework =" 4.5" />
< httpRuntime targetFramework =" 4.5" />
</ system.web >

</ configuration >
```

设置完成调用连接字符串的方法：

```
string str_sql =ConfigurationManager . ConnectionStrings[ 
"BSPOWERConnectionStrings" ]. ConnectionString;
```

---
### 0x01 数据库连接类

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Data.OleDb;
 public class DB
        {
            //切记粘贴复制，否则vs会抱错！！
            string str_sql = ConfigurationManager.ConnectionStrings["BSPOWERConnectionStrings"].ConnectionString;

            public void cmddatabase(string str_cmd)
            {
                OleDbConnection conn = new OleDbConnection(str_sql);
                conn.Open();
                OleDbCommand cmd = new OleDbCommand(str_cmd, conn);
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            public DataSet viewdatabase(string str_cmd)
            {
                OleDbConnection conn = new OleDbConnection(str_sql);
                conn.Open();
                OleDbCommand cmd = new OleDbCommand(str_cmd, conn);
                DataSet ds = new DataSet();
                OleDbDataAdapter adp = new OleDbDataAdapter(cmd);
                adp.Fill(ds);
                conn.Close();
                return ds;
            }
```


