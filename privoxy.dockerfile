ARG ALPINE_VER=3.17.1
FROM alpine:${ALPINE_VER}
ARG ALPINE_VER
LABEL org.opencontainers.image.base.name="alpine:${ALPINE_VER}"
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.title=privoxy
LABEL autoheal=true
ARG PRIVOXY_VER=3.0.33
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
## Build privoxy
RUN apk --update --upgrade --no-cache --no-progress add \
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
  util-linux-misc \
  && mkdir -p /etc/privoxy \
  && mkdir -p /var/log/privoxy \
  && cd /tmp/ \
  && curl -sLJO "https://sourceforge.net/projects/ijbswa/files/Sources/${PRIVOXY_VER}%20%28stable%29/privoxy-${PRIVOXY_VER}-stable-src.tar.gz/download" \
  && tar xzvf privoxy-${PRIVOXY_VER}-stable-src.tar.gz \
  && cd privoxy-${PRIVOXY_VER}-stable \
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
  ## cleanup
  ## remove unnecessary packages
  && apk --no-progress del \
  alpine-sdk \
  autoconf \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  util-linux-misc \
  ## remove temp files
  && rm -rf \
  /tmp/* \
  /var/tmp/*
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --interval=1m \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
