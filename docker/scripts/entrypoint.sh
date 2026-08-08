#!/command/with-contenv bash
set -eu

until pgrep -f '/lsiopy/bin/.*selkies' >/dev/null 2>&1; do
    sleep 1
done

selkies-resize "${SELKIES_MANUAL_WIDTH}x${SELKIES_MANUAL_HEIGHT}"

settings_file=/home/ubuntu/.local/share/cavestory-nx/nxengine/settings.dat
if [ -f "$settings_file" ] && [ "$(dd if="$settings_file" bs=1 count=4 2>/dev/null)" = NXS3 ]; then
    printf '\10\0\0\0' | dd of="$settings_file" bs=1 seek=4 conv=notrunc status=none
    printf '\1' | dd of="$settings_file" bs=1 seek=14 conv=notrunc status=none
fi

exec s6-setuidgid abc /opt/cavestory/cavestory-nx
