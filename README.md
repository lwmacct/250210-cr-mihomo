## 镜像仓库
- 代码仓库: https://github.com/lwmacct/250210-cr-mihomo
- 配置文档: https://wiki.metacubex.one/config/general/
- 配置示例: https://github.com/MetaCubeX/mihomo/blob/Meta/docs/config.yaml

## 运行示例
```bash
#!/usr/bin/env bash

__main() {

  {
    # 镜像准备
    _image1="registry.cn-hangzhou.aliyuncs.com/lwmacct/mihomo:v1.191.1-amd64-t250206"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then
      docker pull $_image1
      _image2="$(docker images -q $_image1)"
    fi
  }

  _apps_name="mihomo"
  _apps_data="/data/$_apps_name"
  cat <<EOF | docker compose -p "$_apps_name" -f - up -d --remove-orphans
services:
  main:
    container_name: $_apps_name
    image: "$_image2"
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - $_apps_data:/apps/data
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

## 容器工作路径文件概览
+ 只需要修改`mihomo/config.yaml` 
+ webui http://localhost:9090/ui

```bash
╭─root@root /data/mihomo 
╰─# tree -L 2
.
├── cron.d
├── logs
│   └── entry.log
├── mihomo
│   ├── cache.db
│   ├── config.yaml
│   ├── geoip.dat
│   ├── geoip.metadb
│   ├── geosite.dat
│   ├── proxies
│   ├── rules
│   └── ui
├── script
│   ├── run.sh
│   └── start.sh
├── w.code-workspace
└── workspace

9 directories, 9 files
```