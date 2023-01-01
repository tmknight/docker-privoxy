FROM alpine:3.17.0
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.title=privoxy
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL autoheal=true
ARG PRIVOXYVERSION=3.0.33
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
## Build privoxy
RUN passwd -l root 2>/dev/null \
  && apk --update --upgrade --no-cache --no-progress add \
  bash \
  alpine-sdk \
  autoconf \
  pcre \
  pcre-dev \
  zlib \
  zlib-dev \
  openssl \
  openssl-dev \
  && addgroup -S -g 1000 privoxy 2>/dev/null \
  && adduser -S -H -D \
  -h /home/privoxy \
  -s /bin/bash \
  -u 1000 \
  -G privoxy privoxy 2>/dev/null \
  && passwd -l privoxy 2>/dev/null \
  && mkdir -p /etc/privoxy \
  && mkdir -p /var/log/privoxy \
  && mkdir -p /usr/src \
  && cd /usr/src \
  && wget "https://www.privoxy.org/sf-download-mirror/Sources/${PRIVOXYVERSION}%20%28stable%29/privoxy-${PRIVOXYVERSION}-stable-src.tar.gz" \
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
  && make \
  && make -s install \
  && cd / \
  && rm -rf /usr/src \
  && chown -R privoxy:privoxy /var/log/privoxy \
  && apk --no-progress del \
  alpine-sdk \
  zlib-dev \
  openssl-dev \
  pcre-dev \
  autoconf
## Build user manual
RUN apk --update --upgrade --no-cache --no-progress add \
  curl \
  tzdata \
  jq \
  ## user manual required for config links to work
  && mkdir -p /usr/share/doc/privoxy \
  && curl -sLJo /tmp/privoxy-user-manual.tar.gz 'https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=2d204d1a6a3d927e1973f60892d0294661b9cc5c;sf=tgz' \
  && tar xC /usr/share/doc/privoxy/ -f /tmp/privoxy-user-manual.tar.gz \
  && mv /usr/share/doc/privoxy/privoxy-2d204d1 /usr/share/doc/privoxy/user-manual \
  ## cleanup
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
