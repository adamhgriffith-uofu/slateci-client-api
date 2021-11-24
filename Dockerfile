# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image build arguments:
ARG env=dev
ARG token
ARG username

# Docker container environmental variables:
ENV SLATE_API_USER=${username}
ENV SLATE_ENV=${env}

# Package installs/updates:
RUN dnf install openssh-clients -y

# Download and install the SLATE CLI:
RUN curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz && \
    curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.sha256
RUN sha256sum -c slate-linux.sha256 || exit 1
RUN tar xzvf slate-linux.tar.gz && \
    mv slate /usr/bin/slate && \
    rm slate-linux.tar.gz slate-linux.sha256

# Prepare entrypoint:
COPY ./docker-entrypoint.sh ./
RUN chmod +x ./docker-entrypoint.sh

# Set the work directory:
RUN mkdir /work

# Add the SLATE resource files:
COPY ./resources ./resources
RUN chmod +x /resources/yml.sh

# Change working directory:
WORKDIR /root

# Set the SSH private key:
COPY ./ssh/id_rsa_slate ./.ssh/id_rsa_slate

# Set SLATE home:
RUN mkdir -p -m 0700 ./.slate

# Set the token:
RUN echo ${token} > ./.slate/token && \
    chmod 600 ./.slate/token

# Volumes
VOLUME [ "/work" ]

# Run once the container has started:
ENTRYPOINT [ "/docker-entrypoint.sh" ]