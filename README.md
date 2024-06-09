# Cross Wails

Docker Image for Cross Compiling [Wails Applications](https://wails.io/)

## Usage

You can use this image as a base image in your own Dockerfile:

```dockerfile
FROM ghcr.io/abjrcode/cross-wails:v2.8.2 as base

# Use `wails build` to build your application
```

Check out the [example](./example) directory for a complete example that demonstrates
building a Wails applications for Linux ARM64, Linux AMD64 and Windows AMD64

## Details

- Image can cross-compile Wails applications that depend on CGO
  - Supports cross compiling to Linux ARM64 & AMD64 and Windows AMD64
    - Can be extended to support more targets and architectures but then I would
      recommend using [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main)
  - You can also use NSIS for creating Windows installers
- It doesn't support cross compiling to MacOS because Wails doesn't support it yet
- The image tag is the same as Wails version, e.g. `v2.7.1`
- The image is adopted from [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main) but with stripped down dependencies
  to minimize the image size and build time
  - It is still a bit over 4GB though :(

You can also [check the background stroy on my blog](https://madin.dev/cross-wails) if you are interested in more details :D
