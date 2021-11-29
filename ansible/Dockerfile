# syntax=docker/dockerfile:1
FROM slateci-client-api:prod

# Docker image build arguments:
ARG venvdir=/root/venv

# Docker container environmental variables:
ENV PATH=${venvdir}/bin/:$PATH

# Package installs/updates
RUN dnf install python39 -y

# Set aliases
RUN echo 'alias python="/bin/python3.9"' >> "/root/.bashrc"

# Python package installs/updates:
COPY ./submodules/kubespray/requirements.txt ./
RUN /bin/python3.9 -m venv ${venvdir} && \
    source ${venvdir}/bin/activate && \
    pip3 install -r ./requirements.txt

# Run once the container has started:
CMD [ "/bin/bash" ]