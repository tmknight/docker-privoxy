# Docker Privoxy

[![PublishImage][PublishImageBadge]][GitHubPackageLink]
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

[PublishImageBadge]: https://github.com/tmknight/docker-privoxy/actions/workflows/image-orchestration.yml/badge.svg
[GitHubPackageLink]: https://github.com/tmknight/docker-privoxy/pkgs/container/privoxy
[DockerPullsBadge]: https://badgen.net/docker/pulls/tmknight88/privoxy?icon=docker&label=Docker+Pulls&labelColor=31383f&color=32c855
[DockerSizeBadge]: https://badgen.net/docker/size/tmknight88/privoxy/latest?icon=docker&label=Docker+Size&labelColor=31383f&color=32c855
[DockerLink]: https://hub.docker.com/r/tmknight88/privoxy
[GithubDLBadge]: https://img.shields.io/badge/dynamic/json?style=flat&logo=github&labelColor=31383f&color=32c855&url=https%3A%2F%2Fipitio.github.io%2Fbackage%2Ftmknight%2Fdocker-privoxy%2Fprivoxy.json&query=%24.downloads&label=ghcr%20pulls&cacheSeconds=14400
[GithubDLLink]: https://github.com/tmknight/docker-privoxy/pkgs/container/privoxy
