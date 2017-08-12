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
export GO_VERSION=1.8.3
curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
        | tar -xzC /usr/local

export PATH=/go/bin:/usr/local/go/bin:$PATH
export GOPATH=/go

export GO_TOOLS_COMMIT=823804e1ae08dbb14eb807afc7db9993bc9e3cc3

git clone https://github.com/golang/tools.git /go/src/golang.org/x/tools  && (cd /go/src/golang.org/x/tools && git checkout -q $GO_TOOLS_COMMIT)

export GO_LINT_COMMIT=32a87160691b3c96046c0c678fe57c5bef761456

git clone https://github.com/golang/lint.git /go/src/github.com/golang/lint \
  && (cd /go/src/github.com/golang/lint && git checkout -q $GO_LINT_COMMIT) \
  && go install -v github.com/golang/lint/golint
