ARG UBUNTU_VERSION="22.04"
ARG CUDA_VERSION="12.1.1"
ARG CUDNN_VERSION="8.9.2.26"
ARG CUDNN_V="8"
ARG PYTHON_VERSION="3.11"

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_V}-devel-ubuntu${UBUNTU_VERSION} AS base

ARG DEBIAN_FRONTEND=noninteractive

# Additional Packages Installtions
RUN apt update &&  \
    apt -y install --no-install-recommends ubuntu-drivers-common \
    && apt -y install --no-install-recommends locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Do NOT modify UID from 1000
ARG USERNAME=coder
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG USER_GID=$USER_UID
ENV USERNAME=${USERNAME}
ENV USER_UID=${USER_UID}
ENV USER_GID=${USER_GID}

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt update \
    && apt install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && usermod -aG sudo $USERNAME


# Cleanup
# RUN pip3 cache purge # cache is not enabled in the nvcr image
RUN apt autoremove -y
RUN apt clean

USER $USERNAME
# Change Default Shell to Bash
SHELL ["/bin/bash", "-c"]

# Allow container to stop. See: https://github.com/microsoft/vscode-remote-release/issues/3512#issuecomment-1267053890
# NOTE: May affect benchmarking
# NOTE: Long interval is necessary so container is not closed during vscode initialization
CMD while sleep 120 && ps aux | egrep 'vscode.*[b]ootstrap-fork.*extensionHost.*' > /dev/null; do :; done