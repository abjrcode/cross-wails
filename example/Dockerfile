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

RUN wails build -platform linux/arm64,linux/amd64,windows/amd64

ENTRYPOINT [ "/bin/bash" ]

#############################################################

FROM ${BASE_IMAGE}

COPY --from=builder /usr/src/app/build/bin /out

ENTRYPOINT [ "sh", "-c" ]
CMD [ "cp -r /out/. /artifacts/" ]