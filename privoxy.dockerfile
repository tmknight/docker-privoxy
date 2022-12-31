FROM ubuntu:22.04 as privoxySSL
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -qq \
&& apt install -qq -y \
privoxy \
&& apt-get clean -y -qq \
&& rm -rf \
/tmp/* \
/var/cache/apt/archives/* \
/var/lib/apt/lists/* \
/var/tmp/*

FROM alpine:3.17.0
LABEL org.opencontainers.image.description="Privoxy for Docker"
LABEL org.opencontainers.image.title=privoxy
LABEL org.opencontainers.image.source=https://github.com/tmknight/docker-privoxy
LABEL org.opencontainers.image.licenses=GPL-3.0
LABEL autoheal=true
ENV CONFFILE=/etc/privoxy/config \
  PIDFILE=/var/run/privoxy.pid
RUN apk --no-progress update \
  && apk --no-cache --no-progress add \
  curl \
  tzdata \
  jq \
  # privoxy \
  ## user manual required for config links to work
  && mkdir -p /usr/share/doc/privoxy \
  && curl -sLJo /tmp/privoxy-user-manual.tar.gz 'https://www.privoxy.org/gitweb/?p=privoxy.git;a=snapshot;h=2d204d1a6a3d927e1973f60892d0294661b9cc5c;sf=tgz' \
  && tar -xC /usr/share/doc/privoxy/ -f /tmp/privoxy-user-manual.tar.gz \
  && mv /usr/share/doc/privoxy/privoxy-2d204d1 /usr/share/doc/privoxy/user-manual \
  ## cleanup
  && rm -rf \
  /tmp/* \
  /var/tmp/*
COPY --from=privoxySSL /usr/sbin/privoxy /usr/sbin/
COPY --from=privoxySSL /etc/privoxy/ /etc/
COPY --from=privoxySSL /var/lib/privoxy/ /var/lib/
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/ \
  /usr/sbin/
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --interval=1m \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
