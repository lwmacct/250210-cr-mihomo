#!/usr/bin/env bash
# https://www.yuque.com/lwmacct

__main() {
  {
    : # 初始化文件
    if [ ! -f "/apps/data/.init" ]; then
      tar -vcpf - -C /apps/file . | (cd / && tar -xpf - --skip-old-files) && touch /apps/data/.init
    fi
  }
  exec bash /apps/data/start.sh
}

__main
