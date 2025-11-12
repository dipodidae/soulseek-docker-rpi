# Soulseek Docker Container for Raspberry Pi

[![GitHub Last Commit](https://img.shields.io/github/last-commit/dipodidae/soulseek-docker-rpi?style=flat-square&logo=git&label=last%20commit)](https://github.com/dipodidae/soulseek-docker-rpi/commits/master)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dipodidae/soulseek-docker-rpi/build.yml?style=flat-square&logo=github&label=build)](https://github.com/dipodidae/soulseek-docker-rpi/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dipodidae/soulseek-rpi?style=flat-square&logo=docker&label=pulls)](https://hub.docker.com/r/dipodidae/soulseek-rpi)
[![Docker Image Size](https://img.shields.io/docker/image-size/dipodidae/soulseek-rpi?style=flat-square&logo=docker&label=size)](https://hub.docker.com/r/dipodidae/soulseek-rpi)

![Soulseek Docker Container Screenshot](https://i.snag.gy/8dpAbV.jpg)

## Raspberry Pi Support

This fork is configured to run on Raspberry Pi using QEMU emulation:

**Important:** SoulseekQt only provides x86_64 binaries. This image uses the x86_64 version which will be automatically emulated on ARM64 systems (Raspberry Pi 3B+, 4, 5) through Docker's QEMU integration.

### Prerequisites for Raspberry Pi:
1. Enable QEMU emulation support (usually pre-installed on modern Docker):
   ```bash
   docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
   ```
2. Raspberry Pi 3B+, 4, or 5 with 64-bit OS recommended
3. At least 2GB RAM (performance may vary due to emulation)

**Performance Note:** Since Soulseek runs under emulation, performance will be slower than native ARM64 applications. This is a limitation of SoulseekQt not providing ARM binaries.

## Prerequisites

- Docker installed on your machine or server
- Port 6080 open and accessible for noVNC web access (or reverse proxied, nginx example at `soulseek.conf`)
- Ports required by Soulseek open and forwarded from your router to the Docker host machine

## Setup

1. Map port 6080 on the host machine to port 6080 on the Docker container.

- If using a GUI or webapp (e.g., Synology) to manage Docker containers, set this configuration option when launching the container from the image.
- With Docker CLI, use the `-p 6080:6080` option.

2. Map the ports Soulseek uses on the Docker container.

- The first time it runs, Soulseek starts up using a random port. It can also be manually configured in Options -> Login.
- Wait for a Soulseek settings file to appear in `/data/.SoulseekQt/1`, this is saved every 60 minutes by default but can be forced to be more freuquent from Options -> General.
- Map both ports from your router to the machine hosting the Docker image, and from the outside of the Docker image to the server within it. See the [Soulseek FAQ](https://www.slsknet.org/news/faq-page#t10n606) for more details.

3. Launch the Docker container and map the required volumes (see [How to Launch](#how-to-launch) section below).

4. Access the Soulseek UI by opening a web browser and navigating to `http://docker-host-ip:6080` or `https://reverse-proxy`, depending on your configuration.

## Configuration

The container supports the following configuration options:

| Parameter       | Description                                                                   |
| --------------- | ----------------------------------------------------------------------------- |
| `PUID`          | User ID for the container user (optional, requires `PGID`, default: 1000)     |
| `PGID`          | Group ID for the container user (optional, requires `PUID`, default: 1000)    |
| `TZ`            | Timezone for the container (optional, e.g., Europe/London, America/New_York, default: UTC) |
| `VNC_PORT`      | Port for VNC server (optional, default: 5900)                                 |
| `NOVNC_PORT`    | Port for noVNC web access (optional, default: 6080)                           |
| `MODIFY_VOLUMES`| Modify ownership and permissions of mounted volumes (optional, default: true) |
| `UMASK`         | File permission mask for newly created files (optional, default: 022)         |
| `VNCPWD`        | Password for the VNC connection (optional)                                    |
| `VNCPWD_FILE`   | Password file for the VNC connection (optional, takes priority over `VNCPWD`) |

## How to Launch

### Using Docker Compose

```yaml
version: "3"
services:
  soulseek:
    image: dipodidae/soulseek-rpi:latest
    container_name: soulseek
    restart: unless-stopped
    volumes:
      - /persistent/appdata:/data/.SoulseekQt
      - /persistent/downloads:/data/downloads
      - /persistent/logs:/data/logs
      - /persistent/shared:/data/shared
    environment:
      - PUID=${PUID:-1000}
      - PGID=${PGID:-1000}
      - TZ=${TZ:-UTC}
    ports:
      - 6080:6080
      - 61122:61122 # example listening port, check Options -> Login
      - 61123:61123 # example obfuscated port, check Options -> Login
```

### Using Docker CLI

```bash
docker run -d --name soulseek --restart=unless-stopped \
  -v "/persistent/appdata":"/data/.SoulseekQt" \
  -v "/persistent/downloads":"/data/downloads" \
  -v "/persistent/logs":"/data/logs" \
  -v "/persistent/shared":"/data/shared" \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=UTC \
  -p 6080:6080 \
  -p 61122:61122 \ # example listening port, check Options -> Login
  -p 61123:61123 \ # example obfuscated port, check Options -> Login
  dipodidae/soulseek-rpi:latest
```

### Using Docker on Synology DSM

Port Configuration

![Synology Docker Port Configuration](docs/synology_docker_config_ports_screenshot.png)

- Port 6080 is used by noVNC for accessing Soulseek from your local network. Only TCP type is needed.
- Ports 61122 and 61123 are examples; open Soulseek to determine the exact ports to forward. Only TCP type is needed.
- Configure these ports to forward from your router to the machine hosting the Docker image. See the Soulseek Port Forwarding Guide for more details.

Volume Configuration

![Synology Docker Volume Configuration](docs/synology_docker_config_volumes_screenshot.png)

- Mount the required directories for Soulseek data persistence.
- The example mounts an extra directory `/music/FLAC` for sharing; mount the directory you want to share.
