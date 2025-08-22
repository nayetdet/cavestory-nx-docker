#!/bin/bash
set -e
rm /tmp/.X1-lock 2> /dev/null &
/opt/novnc/utils/launch.sh --vnc localhost:5901 --listen 8080 &
echo -e "$TIGER_VNC_PASSWORD\n$TIGER_VNC_PASSWORD" | tigervncserver -geometry $VNC_RESOLUTION -depth 24 :1 -xstartup ./cavestory-nx &
wait
