#!/usr/bin/env bash
# shellcheck disable=SC2317
# document https://www.yuque.com/lwmacct/docker/buildx

__main() {
  {
    _sh_path=$(realpath "$(ps -p $$ -o args= 2>/dev/null | awk '{print $2}')") # 当前脚本路径
    _pro_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-2)}')               # 当前项目名
    _dir_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-1)}')               # 当前目录名
    _image="${_pro_name}:$_dir_name"
  }

  _dockerfile=$(
    # 双引号不转义
    cat <<"EOF"
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

LABEL org.opencontainers.image.source=$_ghcr_source
LABEL org.opencontainers.image.description="lwmacct"
LABEL org.opencontainers.image.licenses=MIT
EOF
  )
  {
    cd "$(dirname "$_sh_path")" || exit 1
    echo "$_dockerfile" >Dockerfile

    _ghcr_source=$(sed 's|git@github.com:|https://github.com/|' ../.git/config | grep url | sed 's|.git$||' | awk '{print $NF}')
    _ghcr_source=${_ghcr_source:-"https://github.com/lwmacct/250210-cr-builder"}
    sed -i "s|\$_ghcr_source|$_ghcr_source|g" Dockerfile
  }

  {
    if command -v sponge >/dev/null 2>&1; then
      jq 'del(.credsStore)' ~/.docker/config.json | sponge ~/.docker/config.json
    else
      jq 'del(.credsStore)' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json
    fi
  }
  {
    _registry="ghcr.io/lwmacct" # 托管平台, 如果是 docker.io 则可以只填写用户名
    _repository="$_registry/$_image"
    echo "image: $_repository"
    docker buildx build --builder default --platform linux/amd64 -t "$_repository" --network host --progress plain --load . && {
      _image_id=$(docker images "$_repository" --format "{{.ID}}")
      if false; then
        docker rm -f sss 2>/dev/null
        docker run -itd --name=sss \
          --restart=always \
          --network=host \
          --privileged=false \
          "$_image_id"
        docker exec -it sss bash
      fi
    }
    docker push "$_repository"

  }
}

__main

__help() {
  cat >/dev/null <<"EOF"
这里可以写一些备注

ghcr.io/lwmacct/250210-cr-mihomo:v1.191.1-amd64-t2502100

EOF
}
