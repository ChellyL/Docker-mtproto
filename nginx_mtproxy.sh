echo ""
echo "######################################"
echo "   nginx-mtproxy 安装    "
echo "######################################"
echo ""
echo "* 使用 ellermister 制作的 nginx-mtproxy docker镜像 "
echo "https://hub.docker.com/r/ellermister/nginx-mtproxy"
echo ""
echo " 安装时可能需要手动确认安装（回车即可）"
echo ""

echo "前序准备ing"

apt update
apt install docker
apt install docker-compose

ip=$(curl -4 ip.sb)
hex=$(head -c 16 /dev/urandom | xxd -ps)

echo ""
echo "准备完毕～"
echo ""

read -p "请设置http端口（1-65535）（默认 80）：" PORT1
if [[ -n $PORT1 ]];then
  port1=$PORT1
else
  port1=80
fi
echo "http端口为 $port1"
echo ""

read -p "请设置https端口（1-65535）（默认 443）：" PORT2
if [[ -n $PORT2 ]];then
  port2=$PORT2
else
  port2=443
fi
echo "https端口为 $port2"
echo ""

read -p "请设置secret（回车自动生成）：" SECRET
if [[ -n $SECRET ]];then
  secret=$SECRET
else
  secret=$hex
fi
echo "secret为 $secret"
echo ""

read -p "请设置伪装访问网站（默认为 bing.com）" DOMAIN
if [[ -n $DOMAIN ]];then
  domain=$DOMAIN
else
  domain="bing.com"
fi
echo "伪装访问网址为 $domain"
echo ""

read -p "是否采用白名单模式（推荐，可应对爬虫和防火墙探测）[y/n]:" WHITE
if [[ "$WHITE" =~ y|Y ]];then
  white="IP"
  echo "请在搭建完成后访问 http://$ip:$port1/add.php 将ip加入白名单中"
else
  white='OFF'
  echo "不开启白名单模式"
fi
echo ""

read -p "是否使用tag[y/n]:" TAG
if [[ "$TAG" =~ y|Y ]];then
  # tag=760d7bfb68e833b3c2dded5d67a8fac6
  echo "请将 $ip:$port"
  echo "secret: $secret"
  echo "发送给 @MTProxybot 以获取推广tag"
  read -p "请输入推广 tag：" tag
  echo "推广tag为 $tag"
else
  tag=''
  echo "不使用tag"
fi



docker pull ellermister/nginx-mtproxy
docker run --name nginx-mtproxy -d -e secret="$secret" -e domain="$domain" -e tag="$tag" -e ip_white_list=$white -p $port1:80 -p $port2:443 ellermister/nginx-mtproxy:latest

sleep 4

ms=$(docker logs nginx-mtproxy >log.txt && cat log.txt |grep "https://t.me/")
secrt="${ms:66}"
echo ""

echo "tg://proxy?server=$ip&port=$port2&secret=$secrt"

cat > ./mtp.txt << EOF
tg://proxy?server=$ip&port=$port2&secret=$secrt
EOF

if [[ "$WHITE" =~ y|Y ]];then
  echo "请在搭建完成后访问 http://$ip:$port1/add.php 将ip加入白名单中"
fi
echo ""
echo "链接可在本目录的 mtp.txt 中查看"
rm log.txt
