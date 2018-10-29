---
title: Django博客(1)Apache2
date:  2016-08-5
tags: ['Django','Apache2']
toc: true
categories: technology

---
### 0x00 部署前的准备
假设你已经有了一个云服务器，并且操作系统是 Ubuntu 14.4。

首先添加一个新的非 root 账号，为了安全起见，并为其赋予 sudo 权限。

```
sudo adduser onejustone
```

```
vim /etc/sudoers
#在 root ALL=(ALL:ALL)ALL 下添加
onejustone ALL=(ALL:ALL)ALL
```

切换用户到 onejustone

```
su onejustone
```

#### 安装 virtualenv
`virtualenv` 算是 Python 世界中的几大神器之一。

```
#安装 virtualenv
sudo apt-get install python-virtualenv

#创建一个新的虚拟环境,名为 ENV
virtualenv ENV

#启动 ENV
source ENV/bin/activate
```

在虚拟环境中安装 Django

```
(ENV)onejustone@ubuntu:~$:pip install django
```

如需退出虚拟环境，使用:

```
(ENV)onejustone@ubuntu:~$:deactivate
```

---
### 0x01 安装数据库和 HTTP 服务器

```
#安装 mysql 服务器
sudo apt-get install mysql-server

#安装客户工具
sudo apt-get install libmysqlclient-dev
```

```
#安装 apache2 以及 mod-wsgi
sudo apt-get install apache2
sudo apt-get install libapache2-mod-wsgi
```


---
### 0x02 开启 Django

由于我们使用了virtualenv来安装Django，所以Django并不在系统的默认路径上。为了让系统正常运行，还需要在wsgi.py中加入：

```
import sys

# 加入virtualenv的路径
sys.path.append('/home/onejustone/ENV/lib/python2.7/site-packages')
```

---
### 0x03 创建Django 项目

#### 创建一个 my_blog 的Django 项目

```
$ django-admin.py startproject my_blog
```

#### 创建一个 article app

```
$ python manage.py startapp article
```


#### 在 my_blog/my_blog/setting.py 下添加新建app

```
INSTALLED_APPS = (
    ...
    'article',  #这里填写的是app的名称
)
```

#### 在 my_blog/my_blog/urls.py 中配置 url

```
from django.conf.urls import url, include
from django.contrib import admin

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^article/', include('article.urls')),
```

#### 在my_blog/article 中添加一个新的 urls.py 文件

```
from django.conf.urls import url
from article import views

urlpatterns = [
    url(r'^$', view.first_page, name='first_age'),
```

#### 在article/views.py 中添加如下业务代码

```
from django.shortcuts import render
from django.http import HttpResponse
def first_page(request):
    return HttpResponse("<p>hello, world</p>")
```
---
### 0x04 配置 Apach2
在apache的配置文件/etc/apache2/apache2.conf中增加下面的配置：

```
# Django
WSGIScriptAlias / /home/onejustone/my_blog/my_blog/wsgi.py
#django 自带的 wsgi.py 文件
WSGIPythonPath /home/onejuston/my_blog
#django 项目所在位置

<Directory /home/onejustone/my_blog/my_blog>
#站点位置
<Files wsgi.py>
  Order deny,allow
  Require all granted
</Files>
</Directory>
```

利用WSGIScriptAlias，我们实际上将URL / 对应了wsgi接口程序。这样，当我们访问根URL时，访问请求会经由WSGI接口，传递给Django 项目 mysite。

重启 apache2

```
sudo /etc/init.d/apache2 restart
```


Ok,现在可以访问到我们的 Django 站点了。



