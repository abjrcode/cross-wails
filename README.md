# Cross Wails

Docker Image for Cross Compiling [Wails Applications](https://wails.io/)

## Usage

You can use this image as a base image in your own Dockerfile:

```dockerfile
FROM ghcr.io/abjrcode/cross-wails:v2.6.0 as base

# Use `wails build` to build your application
```

## Details

- Image can cross-compile Wails applications that depend on CGO
  - Supports cross compiling to Linux ARM64 & AMD64 and Windows AMD64
    - Can be extended to support more targets and architectures but then I would
      recommend using goreleaser-cross-toolchain
  - You can also use NSIS for creating Windows installers
- It doesn't support cross compiling to MacOS because Wails doesn't support it yet
- The image tag is the same as Wails version
- The image is based on [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main) but with stripped down dependencies
  to minimize the image size and build time
  - It is still over 4.5GB though :(
