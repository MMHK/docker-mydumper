FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        libatomic1 \
        libglib2.0-0 \
    && wget https://github.com/maxbube/mydumper/releases/download/v0.10.5/mydumper_0.10.5-1.buster_amd64.deb \
    && dpkg -i mydumper_0.10.5-1.buster_amd64.deb \
    && rm -rf /var/lib/apt/lists/*



CMD ["mydumper", "--help"]
