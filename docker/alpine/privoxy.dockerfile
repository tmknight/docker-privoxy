ARG ALPINE_VER
FROM alpine:${ALPINE_VER}
ARG ALPINE_VER
ARG PRIVOXY_VER
LABEL org.opencontainers.image.base.name="alpine:${ALPINE_VER}"
LABEL org.opencontainers.image.description=DESCRIPTION
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.title=privoxy
LABEL autoheal=true
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid \
  PRIVOXY_VERSION=${PRIVOXY_VER}
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --start-period=10s --timeout=3s \
  CMD pgrep -f privoxy || exit 1
CMD ["/usr/local/bin/start"]
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
  pcre2 \
  pcre2-dev \
  privoxy \
  tzdata \
  zlib \
  zlib-dev \
  brotli \
  brotli-dev \
  util-linux-misc
## Build privoxy
RUN mkdir -p /etc/privoxy \
  && mkdir -p /var/log/privoxy \
  && cd /tmp/ \
  ## Begin source decision
  && VER=$(echo "${PRIVOXY_VER}" | sed 's/\./_/g') \
  && [ "${PRIVOXY_VER}" = "edge" ] && REF="HEAD" || REF="refs/tags/v_${VER}" \
  && curl -sLJ -o privoxy-${PRIVOXY_VER}-src.tar.gz "https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=${REF};sf=tgz" \
  && mkdir ./privoxy-${PRIVOXY_VER} \
  && tar xzvf privoxy-${PRIVOXY_VER}-src.tar.gz -C ./privoxy-${PRIVOXY_VER} --strip-components=1 \
  ## End source decision
  ## Build privoxy
  && cd ./privoxy-${PRIVOXY_VER} \
  && autoheader \
  && autoconf \
  && ./configure \
  --prefix=/usr \
  --sysconfdir=/etc \
  --localstatedir=/var \
  --enable-compression \
  --with-openssl \
  --enable-extended-statistics \
  --with-brotli \
  ##--prefix=/usr \
  ##--localstatedir=/var \
  ##--sysconfdir=/etc \
  ##--with-brotli \
  ##--with-openssl \
  ##--enable-compression \
  ##--enable-extended-statistics \
  ##--enable-external-filters \
  ##--enable-pcre-host-patterns \
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
  pcre2-dev \
  zlib-dev \
  brotli-dev \
  util-linux-misc \
  && rm -rf \
  /tmp/* \
  /var/tmp/*
