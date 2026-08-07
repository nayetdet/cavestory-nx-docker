# Build Stage
FROM ubuntu:24.04 AS builder
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
FROM ghcr.io/selkies-project/selkies/py-example:main-ubuntu24.04
USER 0
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        libpng16-16 \
        libstdc++6 \
        libsdl2-2.0-0 \
        libsdl2-mixer-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/cavestory-nx/cavestory-nx /opt/cavestory/cavestory-nx
COPY --from=builder /src/cavestory-nx/data /opt/cavestory/data
COPY --chown=1000:1000 docker/scripts/entrypoint.sh /usr/local/bin/cavestory-entrypoint

RUN chmod 0755 /usr/local/bin/cavestory-entrypoint \
    && chown -R 1000:1000 /opt/cavestory

ENV SELKIES_ENABLE_BASIC_AUTH=false \
    SELKIES_ENABLE_RESIZE=true \
    SELKIES_ENCODER=jpeg \
    SELKIES_PORT=8081 \
    DISPLAY_SIZEW=1280 \
    DISPLAY_SIZEH=720

WORKDIR /opt/cavestory
VOLUME ["/home/ubuntu"]
EXPOSE 8081
USER 1000
ENTRYPOINT ["/usr/local/bin/cavestory-entrypoint"]
