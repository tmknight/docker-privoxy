FROM ubuntu:22.04
LABEL autoheal=true
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.title=privoxy
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.licenses=GPL-3.0
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get dist-upgrade -qq -y \
  && apt-get install --no-install-recommends -qq -y \
  apt-utils \
  curl \
  ca-certificates \
  tzdata \
  jq \
  privoxy \
  ## user manual required for config links to work
  && rm -R /usr/share/doc/privoxy/user-manual \
  && curl -sLJo /tmp/privoxy-user-manual.tar.gz 'https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=2d204d1a6a3d927e1973f60892d0294661b9cc5c;sf=tgz' \
  && tar -xC /usr/share/doc/privoxy/ -f /tmp/privoxy-user-manual.tar.gz \
  && mv /usr/share/doc/privoxy/privoxy-2d204d1 /usr/share/doc/privoxy/user-manual \
  ## cleanup
  && apt-get remove -qq -y \
  apt-utils \
  && apt-get autoremove -y -qq \
  && apt-get clean -y -qq \
  && rm -rf \
  /tmp/* \
  /var/cache/apt/archives/* \
  /var/lib/apt/lists/* \
  /var/tmp/*
COPY ./privoxy-start.sh /usr/local/bin/start
COPY ./privoxy-healthcheck.sh /usr/bin/healthcheck
RUN chmod -R +x \
  /usr/bin/ \
  /usr/local/bin/
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --interval=1m \
  CMD healthcheck
CMD start
