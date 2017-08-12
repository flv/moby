#!/bin/bash
# ISO 1664 from Dockerfile
# Build outside Docker

apt-get update && sudo apt-get install -y \
        apparmor \
        apt-utils \
        aufs-tools \
        automake \
        bash-completion \
        binutils-mingw-w64 \
        bsdmainutils \
        btrfs-tools \
        build-essential \
        cmake \
        createrepo \
        curl \
        dpkg-sig \
        gcc-mingw-w64 \
        git \
        iptables \
        jq \
        less \
        libapparmor-dev \
        libcap-dev \
        libnl-3-dev \
        libprotobuf-c0-dev \
        libprotobuf-dev \
        libsystemd-journal-dev \
        libtool \
        mercurial \
        net-tools \
        pkg-config \
        protobuf-compiler \
        protobuf-c-compiler \
        python-dev \
        python-mock \
        python-pip \
        python-websocket \
        tar \
        vim \
        vim-common \
        xfsprogs \
        zip \
        --no-install-recommends \
        && pip install awscli==1.10.15



# build Go
curl -fsSL "https://golang.org/dl/go1.8.3.linux-386.tar.gz" | tar -xzC /usr/local
