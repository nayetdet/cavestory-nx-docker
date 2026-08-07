#!/bin/sh
set -eu

export DISPLAY="${DISPLAY:-:20}"

(
    until xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; do
        sleep 1
    done
    exec env SDL_RENDER_DRIVER=software /opt/cavestory/cavestory-nx
) &

exec /etc/container-entrypoint.sh
