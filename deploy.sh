#!/usr/bin/env bash

# https://github.com/yarnpkg/yarn/issues/770

echo "准备开始部署..."
echo "打包文件"
tar -czf public.tar public
echo "上传文件到测试服务器"
scp -r -P 22 -i ${HOME}/.ssh/id_rsa public.tar root@123.206.74.118:/wwwroot
echo "服务器解压中"
ssh -i ${HOME}/.ssh/id_rsa root@123.206.74.118 "cd /wwwroot; rm -rf hexo; tar  --warning=no-unknown-keyword -zxf public.tar; mv public hexo;> /dev/null 2>&1; rm -rf public.tar"
rm -rf public.tar
echo "删除打包文件, 所有工作完成!"
echo "服务器部署完成"
