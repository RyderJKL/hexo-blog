---
title: Django博客(3)Admin  
date:  2016-08-10  
tags: ['Django','Admin']
toc: true
categories: technology

---
### 0x00 创建admin账号

运行如下命令创建admin账号

```
$ python manage.py createsuperuser
Username (leave blank to use 'root'): jack
Email address: 1234@gmail.com
Password: qwer7890
Password (again): 
```

更具提示输入admin的名称，邮箱，密码。

最后启动服务器，访问 IP:8080/amdin，就可以进入管理员页面了。


---
#### 将app 注册到Django管理员站点


编辑 `article/admin.py` 添加如下代码：

```
from django.contrib import admin
from article.models import Article

# Register your models here.
admin.site.register(Article)
```

启动Diango服务器，便可以对 Article 站点页面进行页面管理了。


