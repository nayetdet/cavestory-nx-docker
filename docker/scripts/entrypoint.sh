#!/bin/sh
set -eu

/etc/container-entrypoint.sh &

until pgrep -x selkies >/dev/null 2>&1; do
    sleep 1
done

selkies-resize "${SELKIES_MANUAL_WIDTH}x${SELKIES_MANUAL_HEIGHT}"

settings_file=/home/ubuntu/.local/share/cavestory-nx/nxengine/settings.dat
if [ -f "$settings_file" ] && [ "$(dd if="$settings_file" bs=1 count=4 2>/dev/null)" = NXS3 ]; then
    printf '\12\0\0\0' | dd of="$settings_file" bs=1 seek=4 conv=notrunc status=none
    printf '\1' | dd of="$settings_file" bs=1 seek=14 conv=notrunc status=none
fi

exec /opt/cavestory/cavestory-nx
