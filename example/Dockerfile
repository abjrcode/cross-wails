ARG BASE_IMAGE=golang

FROM ${BASE_IMAGE} as builder

WORKDIR /usr/src/app

SHELL ["/bin/bash", "-c"]

RUN set -x; \
  apt-get update \
  && apt-get install --no-install-recommends -y -qq \
    wget \
    ca-certificates \
    gnupg \
    nsis

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

RUN go install github.com/wailsapp/wails/v2/cmd/wails@v2.6.0

COPY go.mod go.sum ./

RUN go mod download

COPY . .


# Docker injects the value of BUILDARCH into the build process
ARG BUILDARCH

# Needed atm due to https://github.com/wailsapp/wails/issues/1921
RUN set -exo pipefail; \
  if [ "${BUILDARCH}" = "amd64" ]; then \
    GOOS=linux GOARCH=amd64 CC=x86_64-linux-gnu-gcc wails build -platform linux/amd64; \
    GOOS=linux GOARCH=arm64 CC=aarch64-linux-gnu-gcc wails build -skipbindings -s -platform linux/arm64; \
    GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc wails build -skipbindings -s -platform windows/amd64; \
  else \
    GOOS=linux GOARCH=arm64 CC=aarch64-linux-gnu-gcc wails build -platform linux/arm64; \
    GOOS=linux GOARCH=amd64 CC=x86_64-linux-gnu-gcc wails build -skipbindings -s -platform linux/amd64; \
    GOOS=windows GOARCH=amd64 CC=x86_64-w64-mingw32-gcc wails build -skipbindings -s -platform windows/amd64; \
  fi;

ENTRYPOINT [ "/bin/bash" ]

#############################################################

FROM ${BASE_IMAGE}

COPY --from=builder /usr/src/app/build/bin /out

ENTRYPOINT [ "sh", "-c" ]
CMD [ "cp -r /out/. /artifacts/" ]