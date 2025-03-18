#!/usr/bin/env bash

__tmux_func() {
    while true; do
        /apps/bin/mihomo -d /apps/data/mihomo -ext-ctl "127.0.0.1:9090" -ext-ui "ui"
        sleep 10s
    done
}
__tmux_func
