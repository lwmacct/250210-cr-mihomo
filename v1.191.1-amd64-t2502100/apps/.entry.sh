#!/usr/bin/env bash
# Admin https://www.yuque.com/lwmacct

__main() {
    mkdir -p /apps/data/logs
    {
        : # 初始化文件
        if [ ! -f "/apps/data/.init" ]; then
            tar -vcpf - -C /apps/file . | (cd / && tar -xpf - --skip-old-files) && touch /apps/data/.init
        fi
    } 2>&1 | tee /apps/data/logs/entry.log
    exec bash /apps/data/script/start.sh >/apps/data/logs/script~start.log 2>&1
}

__main
