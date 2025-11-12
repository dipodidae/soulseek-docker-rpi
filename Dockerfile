# Multi-platform Soulseek Docker image for Raspberry Pi
# Uses x86_64 Soulseek binary with QEMU emulation on ARM64

FROM --platform=linux/amd64 ubuntu:latest

# Copy build scripts and patches
COPY scripts/ /build-scripts/
COPY ui.patch /tmp/

# Install system dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        binutils \
        ca-certificates \
        curl \
        dbus \
        fonts-noto-cjk \
        locales \
        libegl1 \
        openbox \
        patch \
        python3-numpy \
        tigervnc-standalone-server \
        tigervnc-tools \
        tzdata \
        xz-utils \
        --no-install-recommends && \
    # Generate machine ID and locale
    dbus-uuidgen > /etc/machine-id && \
    locale-gen en_US.UTF-8

# Run installation scripts
RUN chmod +x /build-scripts/*.sh && \
    /build-scripts/install-s6-overlay.sh && \
    /build-scripts/install-novnc.sh && \
    /build-scripts/install-soulseek.sh && \
    /build-scripts/setup-user.sh && \
    /build-scripts/cleanup.sh && \
    rm -rf /build-scripts

ENV DISPLAY=:1 \
    HOME=/tmp \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    VNC_PORT=5900 \
    NOVNC_PORT=6080 \
    PGID=1000 \
    PUID=1000 \
    TZ=UTC \
    UMASK=022 \
    MODIFY_VOLUMES=true \
    XDG_RUNTIME_DIR=/tmp

COPY rootfs /

ENTRYPOINT ["/init"]
