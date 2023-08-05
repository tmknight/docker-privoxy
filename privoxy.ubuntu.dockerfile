ARG UBUNTU_VER=${UBUNTU_VER}
FROM ubuntu:${UBUNTU_VER}
ARG UBUNTU_VER
ARG PRIVOXY_VER
LABEL org.opencontainers.image.base.name="ubuntu:${UBUNTU_VER}"
LABEL org.opencontainers.image.description DESCRIPTION
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.title=privoxy
LABEL autoheal=true
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --start-period=10s --timeout=3s \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
## Begin setup
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get dist-upgrade -qq -y \
  && apt-get install --no-install-recommends -qq -y \
  apt-utils \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  curl \
  jq \
  openssl \
  libssl-dev \
  libpcre3-dev \
  privoxy \
  rename \
  tzdata \
  zlib1g-dev
## Build privoxy
RUN mkdir -p /etc/privoxy \
  && mkdir -p /var/log/privoxy \
  && cd /tmp/ \
  ## Begin source decision
  ## From stable source
  && curl -sLJO "https://www.privoxy.org/sf-download-mirror/Sources/${PRIVOXY_VER}%20%28stable%29/privoxy-${PRIVOXY_VER}-stable-src.tar.gz" \
  && tar xzvf privoxy-${PRIVOXY_VER}-stable-src.tar.gz \
  ## Git snapshot (2023-01-31)
  # && curl -sLJ -o privoxy-${PRIVOXY_VER}-stable-src.tar.gz "https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=f496cc8ffc3f43f6b154a1f4261a38a9b21f7c16;sf=tgz" \
  # && mkdir ./privoxy-${PRIVOXY_VER}-stable \
  # && tar xzvf privoxy-${PRIVOXY_VER}-stable-src.tar.gz -C ./privoxy-${PRIVOXY_VER}-stable --strip-components=1 \
  ## End source decision
  ## Build privoxy
  && cd ./privoxy-${PRIVOXY_VER}-stable \
  && autoheader \
  && autoconf \
  && ./configure \
  --prefix=/usr \
  --sysconfdir=/etc \
  --localstatedir=/var \
  --enable-compression \
  --with-openssl \
  --enable-extended-statistics \
  && make \
  && make -s install USER=privoxy GROUP=nogroup \
  && cd / \
  && chown -R privoxy:nogroup /var/log/privoxy \
  ## we want just the user-manual
  && mv /usr/share/doc/privoxy/user-manual/ /tmp/ \
  && rm -rf /usr/share/doc/privoxy/* \
  && mv /tmp/user-manual/ /usr/share/doc/privoxy/ \
  ## rename config files
  && rename 's/.new//' /etc/privoxy/*.new
## cleanup
## remove unnecessary packages & temp files
RUN apt-get remove -qq -y \
  apt-utils \
  autoconf \
  automake \
  build-essential \
  libssl-dev \
  libpcre3-dev \
  rename \
  zlib1g-dev \
  && apt-get autoremove -y -qq \
  && apt-get clean -y -qq \
  && rm -rf \
  /tmp/* \
  /var/cache/apt/archives/* \
  /var/lib/apt/lists/* \
  /var/tmp/*
