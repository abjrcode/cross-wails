

# Cross Wails

Imagen de Docker para Compilación Cruzada de [Aplicaciones Wails](https://wails.io/)

## Uso

Puedes usar esta imagen como imagen base en tu propio Dockerfile:

```dockerfile
FROM ghcr.io/abjrcode/cross-wails:v2.8.2 as base

# Use `wails build` to build your application
```

Consulta el directorio [example](./example) para un ejemplo completo que demuestra
la compilación de aplicaciones Wails para Linux ARM64, Linux AMD64 y Windows AMD64

## Detalles

- La imagen puede compilar de forma cruzada aplicaciones Wails que dependen de CGO
  - Soporta compilación cruzada a Linux ARM64 & AMD64 y Windows AMD64
    - Se puede extender para soportar más destinos y arquitecturas, pero en ese caso recomendaría
      usar [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main)
  - También puedes usar NSIS para crear instaladores de Windows
- No soporta compilación cruzada a MacOS porque Wails aún no lo soporta
- La etiqueta de la imagen es la misma que la versión de Wails, por ejemplo `v2.7.1`
- La imagen se adopta de [goreleaser-cross-toolchain](https://github.com/goreleaser/goreleaser-cross-toolchains/tree/main) pero con las dependencias reducidas
  para minimizar el tamaño de la imagen y el tiempo de compilación
  - Sin embargo, sigue pesando un poco más de 4GB :(

También puedes [consultar la historia detrás en mi blog](https://madin.dev/cross-wails) si te interesa más detalle :D
