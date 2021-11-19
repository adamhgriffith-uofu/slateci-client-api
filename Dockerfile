# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image arguments:
ARG endpoint
ARG token

RUN mkdir -p -m 0700 "$HOME/.slate"

# Set the endpoint:
RUN echo ${endpoint} > "$HOME/.slate/endpoint"

# Set the token:
RUN echo ${token} > "$HOME/.slate/token" && \
    chmod 600 "$HOME/.slate/token"

# Download and install the CLI:
WORKDIR  /tmp
RUN curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz && \
    curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.sha256
RUN sha256sum -c slate-linux.sha256 || exit 1
RUN tar xzvf slate-linux.tar.gz && \
    mv slate /usr/bin/slate && \
    rm slate-linux.tar.gz slate-linux.sha256

WORKDIR /

ENTRYPOINT /bin/bash