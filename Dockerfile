# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image arguments:
ARG endpoint
ARG token
ARG username

# Package installs/updates:
RUN dnf install openssh-clients -y

# Download and install the CLI:
RUN curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.tar.gz && \
    curl -LO https://jenkins.slateci.io/artifacts/client/slate-linux.sha256
RUN sha256sum -c slate-linux.sha256 || exit 1
RUN tar xzvf slate-linux.tar.gz && \
    mv slate /usr/bin/slate && \
    rm slate-linux.tar.gz slate-linux.sha256

# Prepare entrypoint:
COPY ./entrypoint.sh ./
RUN chmod +x ./entrypoint.sh

# Set the work directory:
RUN mkdir /work

# Set the SLATE API user:
RUN useradd -ms /bin/bash ${username} && \
    chown ${username}:${username} /work
WORKDIR /home/${username}

# Set the SSH private key:
COPY ./ssh/id_rsa ./.ssh/id_rsa
RUN chown -R ${username}:${username} ./.ssh

# Switch to SLATE API user:
USER ${username}

# Set SLATE home:
RUN mkdir -p -m 0700 ./.slate

# Set the endpoint:
RUN echo ${endpoint} > ./.slate/endpoint

# Set the token:
RUN echo ${token} > ./.slate/token && \
    chmod 600 ./.slate/token

# Volumes
VOLUME [ "/work" ]

# Run once the container has started:
ENTRYPOINT [ "/entrypoint.sh" ]