# Build Stage
FROM debian:11.1-slim AS build
ENV DEBIAN_FRONTEND=noninteractive
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

WORKDIR /opt/cavestory-nx
RUN mkdir -p build \
    && cd build \
    && cmake .. \
    && make \
    && cd .. \
    && rm -rf build

# Runtime Stage
FROM b0nam/debian-novnc:base
ARG TIGER_VNC_PASSWORD
ENV TIGER_VNC_PASSWORD=${TIGER_VNC_PASSWORD} \
    DEBIAN_FRONTEND=noninteractive \
    SDL_AUDIODRIVER=dummy

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libpng16-16 \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/cavestory-nx
COPY --from=build /opt/cavestory-nx .
EXPOSE 5901 8080
