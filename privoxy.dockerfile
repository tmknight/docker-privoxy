FROM alpine:3.17.0
LABEL org.opencontainers.image.base.name="alpine:3.17.0"
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.title=privoxy
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL autoheal=true
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
## Build privoxy
ARG PRIVOXYVERSION=3.0.33
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
  && curl -sLJO "https://sourceforge.net/projects/ijbswa/files/Sources/${PRIVOXYVERSION}%20%28stable%29/privoxy-${PRIVOXYVERSION}-stable-src.tar.gz/download" \
  && tar xzvf privoxy-${PRIVOXYVERSION}-stable-src.tar.gz \
  && cd privoxy-${PRIVOXYVERSION}-stable \
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
