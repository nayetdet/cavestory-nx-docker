#!/command/with-contenv bash
set -eu

until pgrep -f 'selkies|pixelflux' >/dev/null 2>&1; do
    sleep 1
done

selkies-resize "${SELKIES_MANUAL_WIDTH}x${SELKIES_MANUAL_HEIGHT}"

exec s6-setuidgid abc /opt/cavestory/cavestory-nx
