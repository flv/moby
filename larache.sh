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

# Get lvm2 source for compiling statically
export LVM2_VERSION=2.02.103
mkdir -p /usr/local/lvm2 \
        && curl -fsSL "https://mirrors.kernel.org/sourceware/lvm2/LVM2.${LVM2_VERSION}.tgz" \
                | tar -xzC /usr/local/lvm2 --strip-components=1

# Compile and install lvm2
cd /usr/local/lvm2 \
        && ./configure \
                --build="$(gcc -print-multiarch)" \
                --enable-static_link \
        && make device-mapper \
        && make install_device-mapper

# Install seccomp: the version shipped upstream is too old
export ENV=SECCOMP_VERSION 2.3.2
set -x \
        && export SECCOMP_PATH="$(mktemp -d)" \
        && curl -fsSL "https://github.com/seccomp/libseccomp/releases/download/v${SECCOMP_VERSION}/libseccomp-${SECCOMP_VERSION}.tar.gz" \
                | tar -xzC "$SECCOMP_PATH" --strip-components=1 \
        && ( \
                cd "$SECCOMP_PATH" \
                && ./configure --prefix=/usr/local \
                && make \
                && make install \
                && ldconfig \
        ) \
        && rm -rf "$SECCOMP_PATH"

# build Go
export GO_VERSION=1.8.3
curl -fsSL "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
        | tar -xzC /usr/local

export PATH=/go/bin:/usr/local/go/bin:$PATH
export GOPATH=/go

# Dependency for golint
export GO_TOOLS_COMMIT=823804e1ae08dbb14eb807afc7db9993bc9e3cc3

git clone https://github.com/golang/tools.git /go/src/golang.org/x/tools  && (cd /go/src/golang.org/x/tools && git checkout -q $GO_TOOLS_COMMIT)

# Grab Go's lint tool
export GO_LINT_COMMIT=32a87160691b3c96046c0c678fe57c5bef761456

git clone https://github.com/golang/lint.git /go/src/github.com/golang/lint \
  && (cd /go/src/github.com/golang/lint && git checkout -q $GO_LINT_COMMIT) \
  && go install -v github.com/golang/lint/golint

# Install CRIU for checkpoint/restore support
export CRIU_VERSION=2.12.1
# Install dependancy packages specific to criu
apt-get install libnet-dev -y && \
        mkdir -p /usr/src/criu \
        && curl -sSL https://github.com/xemul/criu/archive/v${CRIU_VERSION}.tar.gz | tar -v -C /usr/src/criu/ -xz --strip-components=1 \
        && cd /usr/src/criu \
        && make \
        && make install-criu

# mmh
~/flv/moby/hack/make.sh binary
