# pyenv && virtualenv

## pyenv

> 使用 `pyenv` 切换 python 多版本

[pyenv 官网](https://github.com/pyenv/pyenv)

### 安装 pyenv

```bash
# mac
$ brew update
$ brew install pyenv
# linux
$ curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
# centos
```

### 使用

安装指定版本的 python:

```bash
$ pyenv install 3.4.1
$ pyenv rehash #更新数据库
```

卸载指定版本的 python:

```bash
pyenv uninstall 2.7.5
```

查看已近安装的所有版本:

```bash
$ pyenv versions
```

版本切换：

```bash
$ pyenv global 3.4.1 # 全局版本切换
$ pyenv local 2.7.6 # 局部切换
```


## virtualenv

### 安装 virtualenv

这里使用`pyenv`插件的形式安装`virtualenv`的虚拟环境。

[pyenv virtualenv](https://github.com/yyuu/pyenv-virtualenv)是`pyenv`的插件，为`UNIX`系统上的`Python virtualenvs`提供`pyenv virtualenv`命令。

```bash
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
source ~/.bash_profile
```

### 使用

创建一个特定版本的虚拟环境：

```bash
$ pyenv virtualenv 3.6.5 env365
# 将创建名为env365的python虚拟环境，这个环境的真实目录位于：~/.pyenv/versions/
```

删除一个虚拟环境：

```bash
rm -rf ~/.pyenv/versions/env365
# 或者卸载 pyenv uninstall env271
```

切换到新的虚拟环境中：

```bash
# 手动激活
pyenv activate env365
pyenv activate # 切回到系统环境

# 自动激活
# 使用pyenv local 虚拟环境名
# 会把`虚拟环境名`写入当前目录的.python-version文件中
# 关闭自动激活 -> pyenv deactivate
# 启动自动激活 -> pyenv activate env365
pyenv local env365
```




