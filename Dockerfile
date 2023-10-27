# MIT License

# Copyright (c) 2019 Goren G
# Copyright (c) 2020 Artur Troian

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Adopted from Go Releaser Toolchain
# https://github.com/goreleaser/goreleaser-cross-toolchains/blob/main/Dockerfile


FROM --platform=$BUILDPLATFORM debian:bullseye as builder

LABEL maintainer="Ibrahim Najjar <https://github.com/abjrcode/>"
LABEL "org.opencontainers.image.source"="https://github.com/abjrcode/cross-wails"

# TARGETARCH is set by Docker Buildx
ARG TARGETARCH

ENV DEBIAN_FRONTEND=noninteractive
ARG DPKG_ARCH="amd64 arm64"
ARG CROSSBUILD_ARCH="amd64 arm64"
ARG MINGW_VERSION=20230130
ARG MINGW_HOST="ubuntu-18.04"

SHELL ["/bin/bash", "-c"]

RUN set -x; \
  apt-get update \
  && apt-get install --no-install-recommends -y -qq \
    wget \
    ca-certificates \
    gnupg \
    nsis \
  && while read arch; do dpkg --add-architecture $arch; done < <(echo "${DPKG_ARCH}" | tr ' ' '\n') \
  && crossbuild_pkgs=$(while read arch; do echo -n "crossbuild-essential-$arch "; done < <(echo "${CROSSBUILD_ARCH}" | tr ' ' '\n')) \
  && apt-get update \
  && apt-get install --no-install-recommends -y -qq \
        gcc \
        libarchive-tools \
        mingw-w64 \
        ${crossbuild_pkgs} \
  && MINGW_ARCH=$(echo -n $TARGETARCH | sed -e 's/arm64/aarch64/g' | sed -e 's/amd64/x86_64/g') \
  && wget -qO - "https://github.com/mstorsjo/llvm-mingw/releases/download/${MINGW_VERSION}/llvm-mingw-${MINGW_VERSION}-ucrt-${MINGW_HOST}-${MINGW_ARCH}.tar.xz" | bsdtar -xf - \
  && ln -snf $(pwd)/llvm-mingw-${MINGW_VERSION}-ucrt-${MINGW_HOST}-${MINGW_ARCH} /llvm-mingw

# Install Libgtk, webkit and NSIS
RUN dpkg --add-architecture amd64 \
  && apt-get -qq update \
  && apt-get -qq install -y libgtk-3-dev:amd64 libwebkit2gtk-4.0-dev:amd64

RUN dpkg --add-architecture arm64 \
  && apt-get -qq update \
  && apt-get -qq install -y libgtk-3-dev:arm64 libwebkit2gtk-4.0-dev:arm64

ARG NODE_MAJOR_VERSION=18

# Install NodeJS
RUN mkdir -p /etc/apt/keyrings && \
    wget -q -O - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR_VERSION.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get -qq update && apt-get -qq install nodejs -y


# Install Go
ARG GO_VERSION=1.21.3
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz \
 && rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz \
 && rm go${GO_VERSION}.linux-${TARGETARCH}.tar.gz

ENV PATH=$PATH:/root/go/bin:/usr/local/go/bin

RUN apt -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
  && rm -rf /usr/share/man/* \
    /usr/share/doc

ENV CGO_ENABLED=1

# Install Wails
ARG WAILS_VERSION=v2.6.0
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
      CC="x86_64-linux-gnu-gcc"; \
    else \
      CC="aarch64-linux-gnu-gcc"; \
    fi; \
    GOARCH=${TARGETARCH} CC=${CC} go install github.com/wailsapp/wails/v2/cmd/wails@${WAILS_VERSION}


ENTRYPOINT [ "/bin/bash" ]