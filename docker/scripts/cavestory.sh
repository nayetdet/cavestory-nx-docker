#!/command/with-contenv bash
set -eu

mkdir -p /config/.local/share/cavestory-nx
chown -R abc:abc /config/.local/share/cavestory-nx

until pgrep -f 'selkies|pixelflux' >/dev/null 2>&1; do
    sleep 1
done

selkies-resize "${SELKIES_MANUAL_WIDTH}x${SELKIES_MANUAL_HEIGHT}"

until s6-setuidgid abc pactl set-default-sink output >/dev/null 2>&1; do
    s6-setuidgid abc pactl load-module module-null-sink \
        sink_name=output \
        sink_properties=device.description=output >/dev/null 2>&1 || true
    sleep 1
done

exec s6-setuidgid abc /opt/cavestory/cavestory-nx
