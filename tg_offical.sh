echo ""
echo "######################################"
echo "   Telegram Messenger MTProto 安装    "
echo "######################################"
echo ""
echo "* 使用 telegrammessenger 官方 docker 镜像 "
echo "https://hub.docker.com/r/telegrammessenger/proxy/"
echo ""
echo " 安装时可能需要手动确认安装（回车即可）"
echo ""

echo "前序准备ing"

apt update
apt install docker
apt install docker-compose

ip=$(curl -4 ip.sb)
hex=$(openssl rand -hex 16)

echo ""
echo "准备完毕～"
echo ""

read -p "请设置端口（1-65535）（默认 443）：" PORT
if [[ -n $PORT ]];then
  port=$PORT
else
  port=443
fi
echo "端口为 $port"

read -p "请设置secret（回车自动生成）：" SECRET
if [[ -n $SECRET ]];then
  secret=$SECRET
else
  secret=$hex
fi
echo " secret为 $secret"

read -p "是否添加广告频道[y/n]：" AD
if [[ "$AD" =~ y|Y ]];then
  echo "请将 $ip:$port"
  echo "secret: $secret"
  echo "发送给 @MTProxybot 以获取推广tag"
  echo ""
  read -p "请输入频道TAG：" tag
  docker pull telegrammessenger/proxy
  docker run -d -p$port:443 --name=mtproto-proxy --restart=always -v proxy-config:/data -e SECRET=$secret TAG=$tag telegrammessenger/proxy:latest

else
  docker pull telegrammessenger/proxy
  docker run -d -p$port:443 --name=mtproto-proxy --restart=always -v proxy-config:/data -e SECRET=$secret telegrammessenger/proxy:latest

fi

echo "链接为 tg://proxy?server=$ip&port=$port&secret=$secret"
echo ""
echo "配置文件位于 mtp.txt 中"
cat > ./mtp.txt << EOF
tg://proxy?server=$ip&port=$port&secret=$secret
EOF


