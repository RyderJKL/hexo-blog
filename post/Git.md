---
title: Git 篇
---

# Git 篇

关于`git`的基础概念，比如工作区，暂存区，本地仓库，远程仓库以及`git`的基础操作`git add, git commit, git status`等，此处不做记录。

## git diff 查看具体的修改内容

使用 `git status` 命令只能知道目标文件是否修改过，而使用 `git diff`  命令则可以告诉我们具体的修改内容:

```bash
git diff .\readme.txt
diff --git a/readme.txt b/readme.txt
index 00bb7fb..1060e74 100644
--- a/readme.txt
+++ b/readme.txt
@@ -1,2 +1,2 @@
-<B4><B2><C7><B0><C3><F7><D4><C2><B9><E2>
-
+hello, world.
+today is new day.
```

当我们确定了修改的内容的有效性以后就可以使用 `git add` ,`git commit` 提交修改了:

```bash
git add .\readme.txt
git status .\readme.txt
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)
        modified:   readme.txt
git commit -m 'add a new line' .\readme.txt
[master 1848f10] add a new line
 1 file changed, 2 insertions(+), 2 deletions(-)
```

## git log 查看历史修改日志

实际工作中，我们可能会对同一个文件进行多个修改，而当文件有特别大的时候单凭人类的记忆力是绝不能记住所有修改过的地方的,而这时就可以使用 `git log` 命令告诉我们历史记录:

```bash
git log --pretty=oneline
1848f10b57c339f8541c01d68604ff350514fffd add a new line
c38922d79be946390febde044d83049ce32c71ac add first line
```

使用 `--pretty=oneline` 参数将会以最简化的形式显示历史记录。而前面的一大串数字是每个历史版本对象对应的 `ID`。

## git rest

[git reset 详解](https://zhouhao.me/2017/08/27/detailed-explanation-of-git-reset/)

### git rest 回退到指定版本

在 `git` 中，用 `HEAD` 表示当前版本，也就是最新的提交 `1848f10b57c33...`，上一个版本就是 `HEAD^` ，上上一个版本就是 `HEAD^^`，当然往上100个版本写100个^比较容易数不过来，所以写成 `HEAD~100`。

```bash
git log --pretty=oneline
0ce366eb1d784479b66dc519019a144d8cfc26bc add third line
1848f10b57c339f8541c01d68604ff350514fffd add a new line
c38922d79be946390febde044d83049ce32c71ac add first line
```

我们可以看到，`readme.txt` 文件已经有了三个历史版本了,现在使用 `git reset --hard HEAD^` 回到上一版本:

```bash
git reset --hard HEAD^
HEAD is now at 1848f10 add a new line
```

### git rest --hard

如何又回到 `rest` 之前的那个版本,这时可以使用版本 `ID` 回到过去:

```bash
git reset --hard 0ce366eb1d7844
HEAD is now at 0ce366e add third line
git log --pretty=oneline .\readme.txt
0ce366eb1d784479b66dc519019a144d8cfc26bc add third line
1848f10b57c339f8541c01d68604ff350514fffd add a new line
c38922d79be946390febde044d83049ce32c71ac add first line
```

## git revert Vs git reset

[revert与reset的区别](https://www.cnblogs.com/0616--ataozhijia/p/3709917.html)

## git reflog

但若是两天以后再想回到某个历史版本，而这时压根不记得 `commit id` 有怎么办? 使用 `git reflog` 查看命令历史，以便确定要回到哪个版本。


```
git reflog
0ce366e HEAD@{0}: reset: moving to 0ce366eb1d7844
1848f10 HEAD@{1}: reset: moving to HEAD^
0ce366e HEAD@{2}: commit: add third line
1848f10 HEAD@{3}: reset: moving to 1848
c38922d HEAD@{4}: reset: moving to HEAD^
1848f10 HEAD@{5}: commit: add a new line
c38922d HEAD@{6}: commit (initial): add first line
```

> 使用 Git ，我们可以在过去和现在自由的穿梭。

---
### 0x04 工作区和暂存区


---
### 0x05 修改

---
#### git diff HEAD
此外，使用 `git diff HEAD -- readme.txt` 命令可以查看工作区和版本库里面最新版本的区别.

---
#### git checkout --filename

`git checkout -- readme.txt` 意思就是，把 `readme.txt` 文件在工作区的修改全部撤销，这里有两种情况：

一种是 `readme.txt` 自修改后还没有被放到暂存区，现在，撤销修改就回到和版本库一模一样的状态；

一种是 `readme.txt` 已经添加到暂存区后，又作了修改，现在，撤销修改就回到添加到暂存区后的状态。

总之，就是让这个文件回到最近一次 `git commit` 或 `git add` 时的状态。

> `git checkout -- file` 命令中的 `--` 很重要，没有 `--`，就变成了“切换到另一个分支”的命令


---
#### git reset HEAD file
`git reset HEAD fil` 可以在还没有  `commit` 之前将暂存区的修改替换掉 (unstage) 并重新放回到工作区。

就是说 `git reset` 命令既可以回退版本，也可以把暂存区的修改回退到工作区。当我们用 `HEAD` 时，表示最新的版本。

---
## 远程仓库

---
### 0x00 连接 Git
假设你已经安装了 Git 并又有 Git 账号，那么只需进行如下配置:

```
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

注意 `git config` 命令的 `--global` 参数，用了这个参数，表示你这台机器上所有的 Git 仓库都会使用这个配置，当然也可以对某个仓库指定不同的用户名和Email地址。

此外，如果你觉得这种简单的连接方式不放心，你也可以使用 SSH 去连接 Git。

请参考:

---
### 0x01 添加远程仓库
在开始远程同步之前，我们需要在 Github 中创建一个新的仓库，因为不论是将已存在的本地仓库同步到 Git，还是从 Git 克隆到本地，我们都需要这仓库已经存在于云端。

Ok，现在，假设已经在 Git 云端创建好了一个 `Repository`, 这个仓库的名字叫 `SimpleAngularDemo`

---
#### 添加本地仓库到远程

最初我们通过 `git init` 在本地初始化了一个
仓库，就像下面一样:

```
D:\Git-Repository
λ  mkdir SimpleAngularDemo
D:\Git-Repository
λ  cd .\SimpleAngularDemo
D:\Git-Repository\SimpleAngularDemo
D:\Git-Repository\SimpleAngularDemo
λ  git init
Initialized empty Git repository in D:/Git-Repository/SimpleAngularDemo/.git/
```

那么，现在只需要通过如下命令就可以将这个本地的 `SimpleAngularDemo` 和 Git 云端的 `SimpleAngularDemo` 仓库关联在一起了:

```
git remote add origin git@github.com:jack/SimpleAngularDemo.git
git push -u origin master
```

---
#### 从 Github 克隆

最好的方式是先创建远程库，然后，从远程库克隆。

---
#### 实用技巧

如果关联错误了，那么可以使用如下命令取消并重新关联:


```
git remote rm origin
git remote add origin git@github.com:michaelliao/learngit.git
```

如果，第一次关联到一个 Git rmote，但是remote 中的目录不为空，那么需要向将 remote 中的文件 pull 但本地，才能推送，否则会产生如下错误:

```
D:\Git-Repository\SimpleAngularDemoPS>git push -u origin master
error: src refspec master does not match any.
error: failed to push some refs to 'git@github.com:jack/SportsStroe.git'
```

解决这个问题的方式就是先 `pull`，再 `push`：

```
D:\Git-Repository\SimpleAngularDemoPS>git pull origin master
D:\Git-Repository\SimpleAngularDemoPS>git push origin master
Everything up-to-date
```

### git 合并特定 commit 到指定的仓库下

```bash
git cherry-pick feature/2018_03_12_repo the_target_commit_id develop
```

## reference

[progit](http://iissnan.com/progit/)

