echo ""
echo "######################################"
echo "     Highly-opionated MTPROTO 安装    "
echo "######################################"
echo ""
echo "* 使用 nineseconds 制作的 mtproto go docker镜像 "
echo "https://hub.docker.com/r/nineseconds/mtg"
echo ""
echo " 安装时可能需要手动确认安装（回车即可）"
echo ""

echo "前序准备ing"

apt update
apt install docker
apt install docker-compose

ip=$(curl -4 ip.sb)

echo ""
echo "准备完毕～"
echo ""


read -p "请设置端口（1-65535）（默认随机生成）：" PORT
if [[ -n $PORT ]];then
  port=$PORT
else
  port=$RANDOM
fi
echo "https端口为 $port"
echo ""


read -p "请设置伪装访问网站（默认为 bing.com）" DOMAIN
if [[ -n $DOMAIN ]];then
  domain=$DOMAIN
else
  domain="bing.com"
fi
echo "伪装访问网址为 $domain"
echo ""

secret=$(docker run --rm nineseconds/mtg:master generate-secret --hex $domain)
cat > /etc/mtg.toml << EOF
secret = "$secret"
bind-to = "0.0.0.0:3128"
EOF

# docker pull ellermister/nginx-mtproxy
docker rm -f mtg
docker run -d --name mtg -v /etc/mtg.toml:/config.toml -p $port:3128 --restart=always nineseconds/mtg:master
echo ""
echo "tg://proxy?server=$ip&port=$port&secret=$secret"

cat > ./mtp.txt << EOF
tg://proxy?server=$ip&port=$port&secret=$secret
EOF

echo ""
echo "链接可在本目录的 mtp.txt 中查看"
