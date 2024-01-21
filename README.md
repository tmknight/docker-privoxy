# Docker Privoxy

[![PublishImage][PublishImageBadge]][GitHubPackageLink]
[![DockerSize][DockerSizeBadge]][DockerLink]
[![DockerPulls][DockerPullsBadge]][DockerLink]

### The Privoxy non-caching web proxy for Docker

A companion project leveraging [Docker NordVPN](https://github.com/tmknight/docker-nordvpn)

Build based on

- Alpine `latest` stable
  - Updated nightly
- Ubuntu `latest`
  - Updated nightly
- [Privoxy](https://www.privoxy.org/)
  - Stable `3.0.34`
  - Edge `3.0.35`
  - Built from [source](https://www.privoxy.org/gitweb/?p=privoxy.git;a=summary)
  - With support for [SSL inspection](https://www.privoxy.org/faq/misc.html#SSL)

[PublishImageBadge]: https://github.com/tmknight/docker-privoxy/actions/workflows/image-orchestration.yml/badge.svg
[GitHubPackageLink]: https://github.com/tmknight/docker-privoxy/pkgs/container/privoxy
[DockerPullsBadge]: https://badgen.net/docker/pulls/tmknight88/privoxy?icon=docker&label=Docker+Pulls&labelColor=black&color=green
[DockerSizeBadge]: https://badgen.net/docker/size/tmknight88/privoxy/latest?icon=docker&label=Docker+Size&labelColor=black&color=green
[DockerLink]: https://hub.docker.com/r/tmknight88/privoxy
