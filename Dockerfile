# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image build arguments:
ARG env=dev
ARG fabricusername
ARG token
ARG username

# Docker container environmental variables:
ENV FABRIC_API_USER=${fabricusername}
ENV SLATE_API_USER=${username}
ENV SLATE_CLI_TOKEN=${token}
ENV SLATE_ENV=${env}

# Package installs/updates:
RUN dnf install openssh-clients ncurses which -y

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

# Create the docker directory:
RUN mkdir /docker

# Add the SLATE API envs:
COPY ./envs ./docker/envs

# Add the scripts:
COPY ./scripts ./docker/scripts
RUN chmod +x ./docker/scripts/yml.sh

# Change working directory:
WORKDIR /root

# Set the SSH keys:
COPY ./secrets/ssh ./.ssh/
RUN chmod 600 -R ./.ssh/

# Set SLATE home:
RUN mkdir -p -m 0700 ./.slate

# Set the token:
RUN echo ${token} > ./.slate/token && \
    chmod 600 ./.slate/token

# Set the work directory:
RUN mkdir /work

# Volumes
VOLUME [ "/work" ]

# Run once the container has started:
ENTRYPOINT [ "/docker-entrypoint.sh" ]