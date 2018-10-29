# django 数据库

---
title: Django博客(2)Models
date: 2016-08-15
tags: ['Django','Models']
toc: true
categories: technology

---

## 0x01 数据库设置
我们将会通过Django设置数据库，创建第一个模型。

Django默认连接的是SQLite数据库，但是本文将以mysql数据库为例。

## 安装 MySQL

安装 `mysqlclient`:

``` bash
easy_install mysql-python (mix os)
pip install mysql-python (mix os/ python 2)
pip install mysqlclient (mix os/ python 3)
apt-get install python-mysqldb (Linux Ubuntu, ...)
cd /usr/ports/databases/py-MySQLdb && make install clean (FreeBSD)
yum install MySQL-python (Linux Fedora, CentOS ...)
```

首先，打开mysql，并创建一个新的`database`:**myblog**：

```bash
$ mysql -uroot -p
Enter password:
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE villa DEFAULT CHARSET=utf8;
```

在mysql中创建一个`onejustone`账户，并赋予其相关权限:

```bash
mysql> GRANT SELECT, INSERT,UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON myblog.* TO 'onejustone'@'localhost' IDENTIFIED BY '456';
Query OK, 0 rows affected (0.00 sec)
```

然后在Django网站目录`my_blog/my_blog/setting.py`中进行数据连接配置:

```
# Database
# https://docs.djangoproject.com/en/1.10/ref/settings/#databases

DATABASES = {
    'default': {
        #'ENGINE': 'django.db.backends.sqlite3',
        #'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'myblog',
        'USER': 'onejustone',
        'PASSWORD': '456',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

其中，`ENGING`代表相应数据库驱动，比如：`django.db.backends.sqlite3`, `django.db.backends.postgresql`,`django.db.backends.mysql`, or `django.db.backends.oracle`.

`NAME`代表对应数据库的数据库名称。

如果使用默认的SQLite数据库，那么数据库将会时电脑硬盘中的一个文件，NAME所对应的应该该文件的绝对路径。比如`os.path.join(BASE_DIR, 'db.sqlite3')`。


OK，数据库基本配置已经完成，开始创建`model`,确切的讲，就是为数据库布局和添加一些额外的数据。因为在Django的帮助下，我们不用直接编写SQL语句。Django将关系型的表(table)转换成为一个类(class)。而每个记录(record)是该类下的一个对象(object)。我们可以使用基于对象的方法，来操纵关系型的MySQL数据库。

我们在`my_blog/my_blog/models.py`中来创建数据库模型:

```
from __future__ import unicode_literals

from django.db import models

# Create your models here.
class Article(models.Model) :
    title = models.CharField(max_length = 100)  #博客题目
    category = models.CharField(max_length = 50, blank = True)  #博客标签
    date_time = models.DateTimeField(auto_now_add = True)  #博客日期
    content = models.TextField(blank = True, null = True)  #博客文章正文

    #python2使用__unicode__, python3使用__str__
    def __str__(self) :
        return self.title

    class Meta:  #按时间下降排序
        ordering = ['-date_time']
```

每个模型(表)是一个类，每个类都是`django.db.models.Mode`的子类，类中定义的每个变量都代表了数据库中一个字段。

> 其中__str__(self) 函数Article对象要怎么表示自己.

接下来便是需要在`mysite/settings.py`中添加app实例了:

```
# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'article',
]
```

现在Django知道有 article 这个aap了，进一步运行** python manage.py makemigration pools**以告诉Djano我们对models进行了一些修改，并且希望它可以看到如下内容:

```
Migrations for 'polls':
  polls/migrations/0001_initial.py:
    - Create model Choice
    - Create model Question
    - Add field question to choice
```

###### 生成数据库脚本
下面，可以开始数据库迁移前的准备工作， 运行`sqlmigrate`命令，并结合对应模型名称，Django会自动生成对应模块的数据库脚本文件。

```
$ python manage.py sqlmigrate polls 0001
BEGIN;---- Create model Choice--CREATE TABLE "polls_choice" ( "id" serial NOT NULL PRIMARY KEY, "choice_text" varchar(200) NOT NULL, "votes" integer NOT NULL);
```

下一步使用`migtrate`命令进行数据库迁移:

```
$ python manage.py migrate
Operations to perform: Apply all migrations: admin, auth, contenttypes, polls, sessionsRunning migrations: Rendering model states... DONE Applying polls.0001_initial... OK
```

总结:
Python创建数据库模型的三个步骤:
1.在`models.py`中更改数据模式
2.运行`python manage.py makemigrations`为更改创建迁移
3.运行`python manage.py migrate`将这些更改应用到数据库中





