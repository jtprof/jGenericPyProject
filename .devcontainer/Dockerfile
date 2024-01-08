FROM amazonlinux:2023

ARG LAMBDA_RUNTIME_DIR="/var/runtime"
ARG LAMBDA_TASK_ROOT="/var/task"

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN yum clean all \
    && yum -y update \
    && yum -y install \
        aws-cli \
        git \
        jq \
        openssl \
        python3 \
        python3-pip \
        tar \
        unzip \
        wget \
        which \
        zsh

COPY .devcontainer/amazon-root-ca-bundle.pem /tmp/amazon-root-ca-bundle.pem

RUN python3 -m pip install certifi \
    && cat /tmp/amazon-root-ca-bundle.pem >> $(python3 -m certifi)

COPY .devcontainer/requirements.txt /tmp/localtest.txt
COPY requirements.txt /tmp/application.txt

RUN cat /tmp/application.txt /tmp/localtest.txt | sort | uniq > /tmp/requirements.txt \
    && python3 -m pip install -r /tmp/requirements.txt

RUN yum clean all \
    && rm -f /tmp/*

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} --shell /usr/bin/zsh \
    && mkdir -p /etc/sudoers.d \
    && echo "${USERNAME} ALL=\(root\) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

USER $USERNAME
ENV TERM xterm

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
