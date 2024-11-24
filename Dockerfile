# Start from the debian-slim as base image
FROM debian:stable-slim AS base

ADD install_base.sh /tmp/
RUN ./tmp/install_base.sh

ADD install_nix.sh /tmp/
RUN ./tmp/install_nix.sh

ENV \
    ENV=/etc/profile \
    USER=root \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels