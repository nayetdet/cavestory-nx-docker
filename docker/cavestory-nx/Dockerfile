# Base Image
FROM debian:11-slim AS base
ENV DEBIAN_FRONTEND=noninteractive

# Cave Story Build Stage
FROM base AS cavestory-build
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        libpng-dev \
        libsdl2-dev \
        libsdl2-mixer-dev \
        git \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt
RUN git clone https://github.com/coringao/cavestory-nx

WORKDIR /opt/cavestory-nx/build
RUN cmake .. \
    && make -j$(nproc) \
    && rm -rf /opt/cavestory-nx/build

# NoNVC Build Stage
FROM base as nonvc-build
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        git \
        ca-certificates \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt
RUN git clone --branch v1.2.0 --single-branch https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone --branch v0.9.0 --single-branch https://github.com/novnc/websockify.git /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Runtime Stage
FROM base AS runtime
ARG TIGER_VNC_PASSWORD
ENV TIGER_VNC_PASSWORD=${TIGER_VNC_PASSWORD} \
    DISPLAY=:1 \
    VNC_RESOLUTION=640x480 \
    TERM=xterm \
    SDL_AUDIODRIVER=dummy \
    SDL_VIDEO_CENTERED=1

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        python \
        procps \
        libpng16-16 \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
        xvfb \
        xauth \
        xterm \
        tigervnc-standalone-server \
        tigervnc-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=cavestory-build /opt/cavestory-nx /opt/cavestory-nx
COPY --from=nonvc-build /opt/novnc /opt/novnc
COPY entrypoint.sh /opt/cavestory-nx/entrypoint.sh
RUN chmod +x /opt/cavestory-nx/entrypoint.sh

EXPOSE 5901 8080
WORKDIR /opt/cavestory-nx
ENTRYPOINT ["./entrypoint.sh"]
