FROM alpine:latest
RUN set -eux; \
  sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories; \
  apk add --no-cache tini bash tzdata tar curl wget jq tmux gzip git; \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
  echo "Asia/Shanghai" > /etc/timezone; \
  echo;

RUN set -eux; \
  mkdir -p /apps/bin; \
  cd /apps/bin && \
  wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.1/mihomo-linux-amd64-v1.19.1.gz && \
  gunzip mihomo-linux-amd64-* && \
  mv mihomo-linux-amd64-* mihomo &&  \
  chmod +x mihomo; \
  echo;

RUN set -eux; \
  mkdir -p /apps/file/apps/data/mihomo && cd /apps/file/apps/data/mihomo || exit 1; \
  rm -rf geoip.dat geoip.metadb geosite.dat ui; \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat && \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat && \
  wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb && \
  git clone https://github.com/metacubex/metacubexd.git -b gh-pages ui && rm -rf ui/.git && \
  echo;

COPY apps/ /apps/
WORKDIR /apps/data
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "bash /apps/.entry.sh & exec crond  -f"]
# CMD ["tmux", "new-session", "-s", "tmux", "sleep infinity"]

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250210-cr-mihomo
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
