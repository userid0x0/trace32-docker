# TRACE32 Dockerfile
## Building
```
podman build --tag trace32 --build-arg T32ZIP=<file>.zip --build-arg T32EXE=<executable>  .
```
Example use `trace32_N_2023_01_000155374_ARM_FULL_20230110132230.zip` and start `t32marm`.
```
podman build --tag trace32 --build-arg T32ZIP=trace32_N_2023_01_000155374_ARM_FULL_20230110132230.zip --build-arg T32EXE=t32marm  .
```
## Test
Without any parameters the container should start a TRACE32 instruction set simulator.
```
podman run --rm --interactive --tty --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=${DISPLAY} trace32
```
## Configuration
### Build Arguments
- `T32ZIP` TRACE32 ZIP file to unpack in container
- `T32EXE` TRACE32 executable to start within container
### Environment
- `DISPLAY`
### Volumes
- `/tmp/.X11-unix`
- `/t32work` should contain the files
  - `config.t32` - mandatory
  - `work-settings.cmm` - optional
### Ports
- UDP `10000` used for Intercom `--publish <hostport>:10000`
- TCP `20000` used for RemoteAPI `--publish <hostport>:20000`
## Examples
Start TRACE32, connect to PowerDebug via Ethernet. Expose RemoteAPI Port to localhost (127.0.0.1) port 20000 IPv4 only.
```
cat << EOF > config.t32
PBI=
NET
NODE=E0123456789

; T32 Intercom
IC=NETASSIST
PORT=10000

; T32 API Access (TCP)
RCL=NETTCP
PORT=20000
EOF

podman run --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=${DISPLAY} --volume .:/t32work --publish 127.0.0.1:20000:20000 trace32
```