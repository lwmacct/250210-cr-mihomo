# README.md

# Related Links

- 代码仓库: https://github.com/lwmacct/250210-cr-mihomo
- 配置文档: https://wiki.metacubex.one/config/general/
- 配置示例: https://github.com/MetaCubeX/mihomo/blob/Meta/docs/config.yaml
- 使用示例: https://www.yuque.com/lwmacct/gfw/mihomo (私有)

```bash
#!/usr/bin/env bash

__main() {
  {
    # 镜像准备
    _proxy="ghcr.nju.edu.cn/"
    _image1="${_proxy}ghcr.io/lwmacct/250210-cr-mihomo:latest"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then
      docker pull $_image1
      _image2="$(docker images -q $_image1)"
    fi
  }

  _app_name="mihomo"
  _app_data="/data/project/$_app_name"
  cat <<EOF | docker compose -p "$_app_name" -f - up -d --remove-orphans
services:
  main:
    container_name: $_app_name
    image: "$_image2"
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - $_app_data:/app/data
    environment:
      - TZ=Asia/Shanghai
EOF
}

__help() {
  cat <<EOF

EOF
}

__main

```
