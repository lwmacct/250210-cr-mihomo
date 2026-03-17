FROM alpine:latest
RUN set -eux; \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
  apk add --no-cache tini bash tzdata tar curl wget jq tmux gzip git; \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
  echo "Asia/Shanghai" > /etc/timezone; \
  echo;

RUN set -eux; \
  mkdir -p /app/bin; \
  cd /app/bin && \
  _tag_name=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest | jq -r '.tag_name') && \
  echo "Latest mihomo tag_name: $_tag_name" && \
  wget https://github.com/MetaCubeX/mihomo/releases/download/$_tag_name/mihomo-linux-amd64-$_tag_name.gz && \
  gunzip mihomo-linux-amd64-* && \
  mv mihomo-linux-amd64-* /usr/local/bin/mihomo &&  \
  chmod +x /usr/local/bin/mihomo; \
  echo;

RUN set -eux; \
  mkdir -p /app/file/app/data && cd /app/file/app/data || exit 1; \
  rm -rf geoip.dat geoip.metadb geosite.dat ui; \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat && \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat && \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb && \
  git clone https://github.com/metacubex/metacubexd.git -b gh-pages ui && rm -rf ui/.git && \
  echo;

COPY app/ /app/
WORKDIR /app/data
ENTRYPOINT ["tini", "--"]
CMD ["bash", "/app/.entry.sh"]

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250210-cr-mihomo
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
