# Run / Build Example

This is a vanilla Wails application that was created by running:

```bash
wails init -n example -t vanilla
```

The only addition is the Dockerfile that is used to cross compile the application.

Try out it by running:

```bash
docker build -t example_builder .
```

Then run the container to extract the build artifacts:

```bash
docker run --rm -v $(pwd)/build/bin:/artifacts example_builder
```
