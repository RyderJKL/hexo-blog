# nginx

[nginx](http://cnt1992.xyz/2016/03/18/simple-intro-to-nginx/)

## 安装

## 基础配置

mac 下 nginx 配置文件所在目录: `/usr/local/etc/nginx/ngix/nginx.conf`

```conf
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

pid logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        #listen       8080;
        #server_name  localhost;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

        #location / {
        #    root   html;
        #    index  index.html index.htm;
        #}

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
    include servers/*;
}
```

首先把所有的 `sever`配置全部放在 `nginx.conf` 目录所在的`servers`目录下。

创建一个默认配置文件`default.conf`:

```conf
server {
    # 监听端口
    listen       8087;
    # 域名设定，可以有多个
    server_name  jack.com;
    root /Users/chenrong/test/www; # 该项要修改为你准备存放相关网页的路径
    location / {
      # 定义路径下默认访问的文件名
        index index.php;
    # 打开目录浏览功能，可以列出整个目录
        autoindex on;
    }
    #proxy the php scripts to php-fpm
    location ~ \.php$ {
    # fastcgi配置
        include /usr/local/etc/nginx/fastcgi.conf;
    # 指定是否传递4xx和5xx错误信息到客户端
        fastcgi_intercept_errors on;
    # 指定FastCGI服务器监听端口与地址，可以是本机或者其它
        fastcgi_pass   127.0.0.1:9000;
    }
}
```

在`/Users/chenrong/test/www`下`index.php`文件内容如下：

```php
<?php
echo 'hello meitu!';
?>
```

重启 nginx:

```bash
sudo nginx -s reload
```

可能遇到如下错误：

```bash
nginx: [error] invalid PID number "" in "/usr/local/var/run/nginx/nginx.pid"
```

原因是 nginx 没有找到`.conf`配置文件，手动指定配置文件路径：

```bash
sudo  nginx -c /usr/local/etc/nginx/nginx.conf
```

最后访问`http://localhost:8087/`

## 隐藏端口访问

如果不希望每次打开网页都要输入端口号的话，那么请在终端执行下面命令：

```bash
# 下面的1.13.9请根据最新安装版本号对应修改
sudo chown root:wheel /usr/local/Cellar/nginx/1.13.9/bin/nginx
sudo chmod u+s /usr/local/Cellar/nginx/1.13.9/bin/nginx
```

