echo ""
echo "######################################"
echo "      Erlang MTProto Proxy 安装    "
echo "######################################"
echo ""
echo "* 使用 seriyps 制作的 erlang-docker 镜像 "
echo "https://hub.docker.com/r/seriyps/mtproto-proxy"
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

read -p "请设置端口（1-65535）（回车随机生成）：" PORT
if [[ -n $PORT ]];then
  port=$PORT
else
  port=$RANDOM
fi
echo "端口为 $port"
echo ""

read -p "请设置secret（回车自动生成）：" SECRET
if [[ -n $SECRET ]];then
  secret=$SECRET
else
  secret=$hex
fi
echo "secret为 $secret"
echo ""

read -p "是否添加 推广tag(不知道是啥就不用加这个) [y/n]:" TAG
if [[ "$TAG" =~ y|Y ]];then
  echo "请将 $ip:$port"
  echo "secret: $secret"
  echo "发送给 @MTProxybot 以获取推广tag"
  read -p "请输入推广 tag：" tag
  echo "推广tag为 $tag"
else
  tag='dcbe8f1493fa4cd9ab300891c0b5b326'
  echo "不添加ad tag"
fi
echo ""

docker pull seriyps/mtproto-proxy
docker run -d --name=mtproto --network=host seriyps/mtproto-proxy -p $port -s $secret -t $tag -a dd

echo "链接为 tg://proxy?server=$ip&port=$port&secret=dd$secret"
echo "或 tg://proxy?server=$ip&port=$port&secret=ee$secret$tag"
echo ""
echo "链接可在本目录的 mtp.txt 中查看"
cat > ./mtp.txt << EOF
tg://proxy?server=$ip&port=$port&secret=dd$secret
tg://proxy?server=$ip&port=$port&secret=ee$secret$tag
EOF


