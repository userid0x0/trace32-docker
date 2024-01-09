# TRACE32 Dockerfile
Image with TRACE32, GUI is drawn using a container local X-Server that is accessible using KasmVNC.
The image is based on [Linuxserver.io Webtop](https://docs.linuxserver.io/images/docker-webtop)
## Building
```bash
podman build --tag trace32 --build-arg T32ZIP=<file>.zip --build-arg T32EXE=<executable>  .
```
Example use `trace32_N_2023_01_000155374_ARM_FULL_20230110132230.zip`, password `1234` and start `t32marm`.
```bash
podman build --tag trace32 --build-arg T32ZIP=trace32_N_2023_01_000155374_ARM_FULL_20230110132230.zip --build-arg UNZIP_ARG="-P 1234" --build-arg T32EXE=t32marm  .
```

## Test
Without any parameters the container should start a TRACE32 instruction set simulator. The port `3000` is used to access the webserver within the container.
```bash
podman run --rm --publish 127.0.0.1:3000:3000 trace32
```
Now open `http://127.0.0.1:3000` within your favorite webbrowser (e.g. Firefox/Chrome) on the host.

## Configuration
### Build Arguments
- `T32ZIP` TRACE32 ZIP file to unpack in container
- `T32EXE` default TRACE32 executable to start within container
- `UNZIP_ARG` Arguments for Linux `unzip` e.g. `-P <password>`
### Environment
- `T32EXE` override TRACE32 executable to start within container
- please check also the [Linuxserver.io Webtop](https://docs.linuxserver.io/images/docker-webtop) documentation
### Volumes
- `/t32work` should contain the files
  - `config.t32` - mandatory
  - `work-settings.cmm` - optional
### Ports
- UDP `10000` used for Intercom `--publish <hostport>:10000`
- TCP `20000` used for RemoteAPI `--publish <hostport>:20000`
