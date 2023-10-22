ARG ALPINE_VER
FROM alpine:${ALPINE_VER}
ARG ALPINE_VER
ARG PRIVOXY_VER
LABEL org.opencontainers.image.base.name="alpine:${ALPINE_VER}"
LABEL org.opencontainers.image.description DESCRIPTION
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.title=privoxy
LABEL autoheal=true
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --start-period=10s --timeout=3s \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
## Core scripts
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/
## Ensure alpine updated & add required packages for privoxy
RUN apk update \
  && apk upgrade --no-cache --no-progress --purge \
  && apk add --update --upgrade --no-cache --no-progress --purge --quiet \
  alpine-sdk \
  autoconf \
  curl \
  jq \
  openssl \
  openssl-dev \
  pcre \
  pcre-dev \
  privoxy \
  tzdata \
  zlib \
  zlib-dev \
  util-linux-misc
## Build privoxy
RUN mkdir -p /etc/privoxy \
  && mkdir -p /var/log/privoxy \
  && cd /tmp/ \
  ## Begin source decision
  ## Sourceforge stable
  && curl -sLJO "https://www.privoxy.org/sf-download-mirror/Sources/${PRIVOXY_VER}%20%28stable%29/privoxy-${PRIVOXY_VER}-stable-src.tar.gz" \
  && tar xzvf privoxy-${PRIVOXY_VER}-stable-src.tar.gz \
  ## Git snapshot (2023-01-31)
  # && curl -sLJ -o privoxy-${PRIVOXY_VER}-stable-src.tar.gz "https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=HEAD;sf=tgz" \
  # && mkdir ./privoxy-${PRIVOXY_VER}-stable \
  # && tar xzvf privoxy-${PRIVOXY_VER}-stable-src.tar.gz -C ./privoxy-${PRIVOXY_VER}-stable --strip-components=1 \
  ## End source decision
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
  && make -s install \
  && cd / \
  && chown -R privoxy:privoxy /var/log/privoxy \
  ## we want just the user-manual
  && mv /usr/share/doc/privoxy/user-manual/ /tmp/ \
  && rm -rf /usr/share/doc/privoxy/* \
  && mv /tmp/user-manual/ /usr/share/doc/privoxy/ \
  ## rename config files
  && rename -a '.new' '' /etc/privoxy/*.new \
  ## cleanup; remove unnecessary packages & temp files
  && apk del --no-progress --purge --quiet \
  alpine-sdk \
  autoconf \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  util-linux-misc \
  && rm -rf \
  /tmp/* \
  /var/tmp/*
