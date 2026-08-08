# Build Stage
FROM ubuntu:resolute AS build
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
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release \
    && cmake --build build --parallel \
    && test -x cavestory-nx

# Runtime Stage
FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute AS runtime
USER root
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --chown=abc:abc --from=build /src/cavestory-nx/cavestory-nx /opt/cavestory/cavestory-nx
COPY --chown=abc:abc --from=build /src/cavestory-nx/data /opt/cavestory/data
COPY --chmod=0755 docker/scripts/entrypoint.sh /usr/local/bin/cavestory-entrypoint
COPY docker/assets/fullscreen.css /usr/share/selkies/selkies-dashboard/assets/fullscreen.css
RUN sed -i 's#</head>#<link rel="stylesheet" href="./assets/fullscreen.css"></head>#' /usr/share/selkies/selkies-dashboard/index.html

ENV DISPLAY=:20 \
    SDL_RENDER_DRIVER=software \
    START_LXQT=false \
    CUSTOM_PORT=3939 \
    SELKIES_PORT=3939 \
    SELKIES_ENCODER=jpeg \
    SELKIES_FRAMERATE=50-50 \
    SELKIES_ENABLE_BASIC_AUTH=false \
    SELKIES_ENABLE_RESIZE=false\|locked \
    SELKIES_UI_SHOW_SIDEBAR=false\|locked \
    SELKIES_IS_MANUAL_RESOLUTION_MODE=true\|locked \
    SELKIES_MANUAL_WIDTH=1366 \
    SELKIES_MANUAL_HEIGHT=768 \
    HOME=/config

VOLUME ["/config"]
EXPOSE 3939

WORKDIR /opt/cavestory
USER abc
ENTRYPOINT ["/usr/local/bin/cavestory-entrypoint"]
