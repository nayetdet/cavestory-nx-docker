# Build Stage
FROM debian:trixie AS build
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        ca-certificates \
        cmake \
        libpng-dev \
        libsdl2-dev \
        libsdl2-mixer-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src/cavestory-nx
COPY docker/submodules/cavestory-nx/ ./
COPY docker/patches/default-settings.patch /tmp/default-settings.patch
RUN patch -p1 < /tmp/default-settings.patch \
    && rm /tmp/default-settings.patch

# hadolint ignore=DL3059
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --parallel \
    && test -x cavestory-nx

# Runtime Stage
FROM lsiobase/selkies:debiantrixie AS runtime
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=abc:abc --from=build /src/cavestory-nx/cavestory-nx /opt/cavestory/cavestory-nx
COPY --chown=abc:abc --from=build /src/cavestory-nx/data /opt/cavestory/data
COPY --chmod=0755 docker/scripts/entrypoint.sh /etc/services.d/cavestory/run

COPY docker/assets/fullscreen.css /usr/share/selkies/selkies-dashboard/assets/fullscreen.css
RUN sed -i 's#</head>#<link rel="stylesheet" href="./assets/fullscreen.css"></head>#' /usr/share/selkies/selkies-dashboard/index.html

ENV DISPLAY=:20 \
    SDL_RENDER_DRIVER=software \
    START_LXQT=false \
    HARDEN_DESKTOP=true \
    DISABLE_OPEN_TOOLS=true \
    DISABLE_SUDO=true \
    DISABLE_TERMINALS=true \
    DISABLE_MOUSE_BUTTONS=true \
    HARDEN_KEYBINDS=true \
    SELKIES_ENCODER=jpeg \
    SELKIES_FRAMERATE=50 \
    SELKIES_AUDIO_ENABLED=true \
    SELKIES_GAMEPAD_ENABLED=true \
    SELKIES_MICROPHONE_ENABLED=false \
    SELKIES_CLIPBOARD_ENABLED=false \
    SELKIES_CLIPBOARD_IN_ENABLED=false \
    SELKIES_CLIPBOARD_OUT_ENABLED=false \
    SELKIES_ENABLE_BINARY_CLIPBOARD=false \
    SELKIES_COMMAND_ENABLED=false \
    SELKIES_FILE_TRANSFERS=none \
    SELKIES_ENABLE_SHARING=false \
    SELKIES_ENABLE_COLLAB=false \
    SELKIES_ENABLE_SHARED=false \
    SELKIES_ENABLE_PLAYER2=false \
    SELKIES_ENABLE_PLAYER3=false \
    SELKIES_ENABLE_PLAYER4=false \
    SELKIES_ENABLE_RESIZE=false \
    SELKIES_UI_SHOW_SIDEBAR=false \
    SELKIES_UI_SHOW_CORE_BUTTONS=false \
    SELKIES_UI_SIDEBAR_SHOW_VIDEO_SETTINGS=false \
    SELKIES_UI_SIDEBAR_SHOW_SCREEN_SETTINGS=false \
    SELKIES_UI_SIDEBAR_SHOW_AUDIO_SETTINGS=false \
    SELKIES_UI_SIDEBAR_SHOW_STATS=false \
    SELKIES_UI_SIDEBAR_SHOW_CLIPBOARD=false \
    SELKIES_UI_SIDEBAR_SHOW_FILES=false \
    SELKIES_UI_SIDEBAR_SHOW_APPS=false \
    SELKIES_UI_SIDEBAR_SHOW_SHARING=false \
    SELKIES_UI_SIDEBAR_SHOW_GAMEPADS=false \
    SELKIES_UI_SIDEBAR_SHOW_FULLSCREEN=false \
    SELKIES_UI_SIDEBAR_SHOW_GAMING_MODE=false \
    SELKIES_UI_SIDEBAR_SHOW_TRACKPAD=false \
    SELKIES_UI_SIDEBAR_SHOW_KEYBOARD_BUTTON=false \
    SELKIES_UI_SIDEBAR_SHOW_SOFT_BUTTONS=false \
    SELKIES_IS_MANUAL_RESOLUTION_MODE=true \
    SELKIES_MANUAL_WIDTH=1366 \
    SELKIES_MANUAL_HEIGHT=768

EXPOSE 3000
WORKDIR /opt/cavestory
ENTRYPOINT ["/init"]
