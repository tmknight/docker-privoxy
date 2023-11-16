# Docker Privoxy

[![GitHubPackage][GitHubPackageBadgeAlpine]][GitHubPackageLink]
[![GitHubPackage][GitHubPackageBadgeUbuntu]][GitHubPackageLink]
[![DockerPublishing][DockerPublishingBadgeAlpine]][DockerLink]
[![DockerPublishing][DockerPublishingBadgeUbuntu]][DockerLink]
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

[GitHubPackageBadgeAlpine]: https://github.com/tmknight/docker-privoxy/actions/workflows/github-package-alpine.yml/badge.svg
[GitHubPackageBadgeUbuntu]: https://github.com/tmknight/docker-privoxy/actions/workflows/github-package-ubuntu.yml/badge.svg
[GitHubPackageLink]: https://github.com/tmknight/docker-privoxy/pkgs/container/privoxy
[DockerPublishingBadgeAlpine]: https://github.com/tmknight/docker-privoxy/actions/workflows/docker-publish-alpine.yml/badge.svg
[DockerPublishingBadgeUbuntu]: https://github.com/tmknight/docker-privoxy/actions/workflows/docker-publish-ubuntu.yml/badge.svg
[DockerPullsBadge]: https://badgen.net/docker/pulls/tmknight88/privoxy?icon=docker&label=Docker+Pulls&labelColor=black&color=green
[DockerSizeBadge]: https://badgen.net/docker/size/tmknight88/privoxy/latest?icon=docker&label=Docker+Size&labelColor=black&color=green
[DockerLink]: https://hub.docker.com/r/tmknight88/privoxy
