#!/usr/bin/env bash
# https://www.yuque.com/lwmacct

__main() {
  {
    : # 初始化文件
    if [ ! -f "/app/data/.init" ]; then
      tar -vcpf - -C /app/file . | (cd / && tar -xpf - --skip-old-files) && touch /app/data/.init
    fi
  }
  exec bash /app/data/start.sh
}

__main
