---
title: Django(1)-MyFirstView
date: 2016-08-15
tags: ['Django','MyFirstApp']
toc: true
categories: technology

---
### 0x00 安装并创建第一个Django Project

启动计算机中的Python，尝试载入Django模块。如果可以成功载入，那么说明Django已经安装好：

```
import django
print (django.VERSION)
```

这里的Django版本为1.10.

否则安装Django

```
pip install django
或者
easy_install django
```

Django安装完成，使用`django-admin startproject`命令创建一个网站根目录:

```
 root ~ PycharmProjects 2 django-admin startproject mysite
```

使用`tree`命令查看其目录结构:

```
 root ~ PycharmProjects mysite 2 tree
.
├── manage.py
└── mysite
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py

1 directory, 5 files
```

我们会发现执行命令后，新建了一个 **mysite** 目录，其中还有一个 **mysite** 目录，这个子目录 mysite 中是一些项目的设置 **settings.py** 文件，
总的urls配置文件 **urls.py** 以及部署服务器时用到的 **wsgi.py**  文件，  **__init__.py** python包的目录结构必须的，与调用有关。


进入mysite目录,启动服务器 **python mamage.py runserver** 然后在浏览器中访问:localhsot:8000

```
 root ~ PycharmProjects mysite 2 python manage.py runserver
Performing system checks...

System check identified no issues (0 silenced).
August 15, 2016 - 03:15:32
Django version 1.10, using settings 'mysite.settings'
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

OK，这样便创建好了一个Django工程，下面在这个工程下添加第一个app。

---
### 0x01 创建第一个app

使用**python mamage.py startapp**来创建一个app
app和project关系是，一个project可以包含多个app，一个app可以被多个project共享。

```
root ~ PycharmProjects mysite 2 python manage.py startapp polls
 root ~ PycharmProjects mysite 2 tree polls
polls
├── admin.py
├── apps.py
├── __init__.py
├── migrations
│   └── __init__.py
├── models.py
├── tests.py
└── views.py

1 directory, 7 files
```

app创建完成以后还需要在mysite/setting.py中添加app的实例:

```
 root  ~  PycharmProjects  mysite  cat mysite/settings.py
# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'polls',
]
```

新建的 app 如果不加到`INSTALL_APPS`中的话, django 就不能自动找到app中的**模板文件**(`app-name/templates/`下的文件)和**静态文件**(`app-name/static/`中的文件) 。

#### 第一个view

打开polls/view.py 并添加如下code：

```
from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def index(request):
    return HttpResponse("<p>Hello, world.You're at the pools index.</p>")
```

声明编码为utf-8, 若是在代码中用到了中文,如果不声明就报错.

view的code写好了，那么便是需要为它创建URL映射了，当通过浏览器访问时才能得到polls.index页面的响应。

因此，还需要在polls目录下创建一个urls.py文件，添加完成以后的polls目录树如下:

```
 root ~ PycharmProjects mysite polls 2 tree
.
├── admin.py
├── apps.py
├── __init__.py
├── migrations
│   └── __init__.py
├── models.py
├── tests.py
├── urls.py
└── views.py

1 directory, 8 files
```

然后在polls/urls.py中添加如下code:

```
from django.conf.urls import url

from polls import views as polls_views
#首先引用polls模块，作为视图并设置别名polls_views

urlpatterns = [
    url(r'^$', polls_views.index, name='index'),
]
```

接下来，需要使根目录下的URLconf指向**polls.urls**模块,那么需要在mysite/urls文件中引入**import for django.conf.urls.include**，并且在**urlpatterns**列表中插入**include()**方法。

```
 root ~ PycharmProjects mysite mysite 2 vim urls.py
from django.conf.urls import url, include
from django.contrib import admin
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^polls/', include('polls.urls')),
]
```

最后，启动服务器:

```
 root ~ PycharmProjects mysite 2 python manage.py runserver
```

使用浏览器访问http://127.0.0.1:8000/polls/，可以看到:Hello, world.You're at the pools index.

OK,到此，我们的第一Python app的第一view就创建成功， 接下来，该看看数据库了。

本文参考:django官方文档

> https://media.readthedocs.org/pdf/django/1.10.x/django.pd

