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
  PIDFILE=/var/run/privoxy.pid \
  PRIVOXY_VERSION=${PRIVOXY_VER}
EXPOSE 8118
VOLUME [ "/etc/privoxy", "/var/lib/privoxy/certs" ]
HEALTHCHECK --start-period=10s --timeout=3s \
  CMD /usr/local/bin/healthcheck
CMD /usr/local/bin/start
## Core scripts
COPY ./scripts/ /usr/local/bin/
RUN chmod -R +x \
  /usr/local/bin/
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
  libpcre2-dev \
  pcre2-utils \
  privoxy \
  rename \
  tzdata \
  zlib1g-dev
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
  && make \
  && make -s install USER=privoxy GROUP=nogroup \
  && cd / \
  && chown -R privoxy:nogroup /var/log/privoxy \
  ## we want just the user-manual
  && mv /usr/share/doc/privoxy/user-manual/ /tmp/ \
  && rm -rf /usr/share/doc/privoxy/* \
  && mv /tmp/user-manual/ /usr/share/doc/privoxy/ \
  ## rename config files
  && rename 's/.new//' /etc/privoxy/*.new \
  ## cleanup
  ## remove unnecessary packages & temp files
  && apt-get remove -qq -y \
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
