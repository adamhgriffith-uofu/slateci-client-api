# syntax=docker/dockerfile:1
FROM rockylinux/rockylinux:8

# Docker image build arguments:
ARG env=dev
ARG token
ARG username

# Docker container environmental variables:
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

# Set the SLATE API user & give /work access:
RUN useradd -ms /bin/bash ${username} && \
    chown -R ${username}:${username} /work

# Add the SLATE resource files:
COPY ./resources ./resources
RUN chmod +x /resources/yml.sh && \
    chown -R ${username}:${username} ./resources/

# Change working directory:
WORKDIR /home/${username}

# Set the SSH private key:
COPY ./ssh/id_rsa_slate ./.ssh/id_rsa_slate
RUN chown -R ${username}:${username} ./.ssh

# Switch to SLATE API user:
USER ${username}

# Set SLATE home:
RUN mkdir -p -m 0700 ./.slate

# Set the token:
RUN echo ${token} > ./.slate/token && \
    chmod 600 ./.slate/token

# Volumes
VOLUME [ "/work" ]

# Run once the container has started:
ENTRYPOINT [ "/docker-entrypoint.sh" ]
# ENTRYPOINT bash