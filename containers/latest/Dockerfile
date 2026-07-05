FROM alpine:latest
ARG TARGETARCH

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
  case "$TARGETARCH" in \
    amd64|arm64) _mihomo_arch="$TARGETARCH" ;; \
    *) echo "Unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
  esac && \
  wget "https://github.com/MetaCubeX/mihomo/releases/download/$_tag_name/mihomo-linux-$_mihomo_arch-$_tag_name.gz" && \
  gunzip "mihomo-linux-$_mihomo_arch-$_tag_name.gz" && \
  mv "mihomo-linux-$_mihomo_arch-$_tag_name" /usr/local/bin/mihomo &&  \
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

COPY containers/latest/app/ /app/
WORKDIR /app/data
ENTRYPOINT ["tini", "--"]
CMD ["bash", "/app/.entry.sh"]

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250210-cr-mihomo
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
