#!/bin/sh
set -eu

export DISPLAY="${DISPLAY:-:20}"

/etc/container-entrypoint.sh &

until pgrep -x selkies >/dev/null 2>&1; do
    sleep 1
done

selkies-resize "${SELKIES_MANUAL_WIDTH}x${SELKIES_MANUAL_HEIGHT}"

exec env SDL_RENDER_DRIVER=software /opt/cavestory/cavestory-nx
