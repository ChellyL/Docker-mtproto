# Docker-mtproto
安装docker版mtproto的脚本

一共有四种，其中：

- offical 那个是tg官方做的，但是两年没更新了，不建议用

```
wget https://raw.githubusercontent.com/ChellyL/Docker-mtproto/main/tg_offical.sh && bash tg_offical.sh
```

- erlang_mtproto是用erlang写的，支持tls和安全连接，我自己测试下来是必须要tag才能正常跑
```
wget https://raw.githubusercontent.com/ChellyL/Docker-mtproto/main/erlang_mtproto.sh && bash erlang_mtproto.sh
```

- go_mtg是用go写的，同样支持tls，无需tag，简单快捷
```
wget https://raw.githubusercontent.com/ChellyL/Docker-mtproto/main/go_mtg.sh && bash go_mtg.sh
```


- nginx_mtproxy我个人认为最安全，除了tls、安全链接外，无需tag，还支持ip白名单模式，减少ip被ban的几率，不过使用稍微麻烦一点点；由于使用了nginx，443端口不能被占用
```
wget https://raw.githubusercontent.com/ChellyL/Docker-mtproto/main/nginx_mtproxy.sh && bash nginx_mtproxy.sh
```
