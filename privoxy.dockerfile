ARG UBUNTU_VER=22.04
FROM ubuntu:${UBUNTU_VER}
ARG UBUNTU_VER
LABEL org.opencontainers.image.base.name="ubuntu:${UBUNTU_VER}"
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.title=privoxy
LABEL autoheal=true
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
  && rm -rf /usr/share/doc/privoxy/* \
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
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --interval=1m \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
