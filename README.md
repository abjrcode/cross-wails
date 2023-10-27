# Cross Wails

Docker Image for Cross Compiling [Wails Applications](https://wails.io/)

## Usage

```dockerfile
FROM ghcr.io/abjrcode/cross-wails:v2.6.0
```

## Details

- Image can compile CGO Wails applications to Linux (ARM64 and AMD64) and Windows (AMD64)
  - You can also use NSIS for creating Windows installers
- It doesn't support cross compiling to MacOS because Wails doesn't support it yet
- The image version (tag) is the same as Wails version
- The image is based on [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main) but with stripped down dependencies
  to minimize the image size and build times
