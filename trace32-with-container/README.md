# TRACE32 Dockerfile
Run TRACE32 within a Container but TRACE32 itself is stored on the host.
## Building
```bash
podman build --tag trace32 .
```
## Test
Per default the container tries to start a `t32marm` instruction set simulator.
```bash
xhost +SI:localuser:$(id -un)
podman run --rm --interactive --tty --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=${DISPLAY} --volume <path to trace32>:/opt/t32 trace32
```
## Configuration
### Environment
- `DISPLAY`
### Volumes
- `/tmp/.X11-unix`
- `/opt/t32` TRACE32 installation
- `/t32work` should contain the files
  - `config.t32` - mandatory
  - `work-settings.cmm` - optional
### Ports
- UDP `10000` used for Intercom `--publish <hostport>:10000`
- TCP `20000` used for RemoteAPI `--publish <hostport>:20000`
## Examples
### PowerDebug via Ethernet 
Start TRACE32 for TriCore (`t32mtc`), connect to PowerDebug via Ethernet. Expose RemoteAPI Port to localhost (127.0.0.1) port 20000 IPv4 only. TRACE32 is installed in `/t32sw`.
```bash
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

podman run --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=${DISPLAY} --volume .:/t32work --volume /t32sw:/opt/t32 --publish 127.0.0.1:20000:20000 trace32 t32mtc
```
### PowerDebug via USB
Start TRACE32 for ARM (`t32marm`), connect to PowerDebug via USB. TRACE32 is installed in `/t32sw`.
```bash
cat << EOF > config.t32
PBI=
USB
NODE=E0123456789
EOF

podman run --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY=${DISPLAY} --volume .:/t32work --volume /t32sw:/opt/t32 --volume /dev/lauterbach/:/dev/lauterbach --volume /dev/bus/usb:/dev/bus/usb trace32 t32marm
```

Note: Please make sure the host machine has the Lauterbach udev rules installed.


