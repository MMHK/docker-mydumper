FROM debian:buster-slim as builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
	build-essential \
	cmake \
	libglib2.0-dev \
	default-libmysqlclient-dev \ 
	zlib1g-dev \
	libpcre3-dev \
	libssl-dev \
    && rm -rf /var/lib/apt/lists/*

env RELEASE_VERSION=0.9.5
RUN set -ex \
    && curl -L -o mydumper.tar.gz --silent https://github.com/maxbube/mydumper/archive/v${RELEASE_VERSION}.tar.gz \
    && tar -xzf mydumper.tar.gz && rm -f mydumper.tar.gz \
    && cd mydumper-${RELEASE_VERSION} \
    && cmake . \
    && make \
    && make install

FROM debian:buster-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libmariadb3 \
	libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bin/mydumper /usr/local/bin/mydumper
COPY --from=builder /usr/local/bin/myloader /usr/local/bin/myloader

CMD ["mydumper", "--help"]
