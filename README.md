# Docker Privoxy

[![PublishImage][DockerPublishingBadge]][GithubDLLink]
[![DockerSize][DockerSizeBadge]][DockerLink]
[![DockerPulls][DockerPullsBadge]][DockerLink]
[![GithubDownloads][GithubDLBadge]][GithubDLLink]

### The Privoxy non-caching web proxy for Docker

A companion project leveraging [Docker NordVPN](https://github.com/tmknight/docker-nordvpn)

Build based on

- Ubuntu `latest` stable
  - Updated nightly
    - stable as `latest`
    - edge as `nightly`
- [Privoxy](https://www.privoxy.org/)
  - Stable `4.x.x`
  - Edge `Latest from Source`
  - Built from [source](https://www.privoxy.org/gitweb/?p=privoxy.git;a=summary)
  - With support for [SSL inspection](https://www.privoxy.org/faq/misc.html#SSL)

I highly recommend [ZeroOmega](https://github.com/sn-o-w/ZeroOmega) browser extension to assist in leveraging Privoxy in your web browsing sessions

[DockerPublishingBadge]: https://img.shields.io/github/actions/workflow/status/tmknight/docker-privoxy/docker-publish.yml?branch=main&style=flat-square&logo=github&label=publish%20image&cacheSeconds=14400
[DockerPullsBadge]: https://img.shields.io/docker/pulls/tmknight88/privoxy?style=flat-square&logo=docker&color=blue&cacheSeconds=14400
[DockerSizeBadge]: https://img.shields.io/docker/image-size/tmknight88/privoxy?sort=date&arch=amd64&style=flat-square&logo=docker&color=blue&cacheSeconds=14400
[DockerLink]: https://hub.docker.com/r/tmknight88/privoxy
[GithubDLBadge]: https://img.shields.io/badge/dynamic/json?style=flat-square&logo=github&url=https%3A%2F%2Fipitio.github.io%2Fbackage%2Ftmknight%2Fdocker-privoxy%2Fprivoxy.json&query=%24.downloads&label=ghcr%20pulls&cacheSeconds=14400
[GithubDLLink]: https://github.com/tmknight/docker-privoxy/pkgs/container/privoxy
