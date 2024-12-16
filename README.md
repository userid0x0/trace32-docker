# trace32-docker

# Images
## trace32-as-container
Image with TRACE32 installed, GUI is drawn on the hosts X-Server.

## trace32-noscreen-as-container
A image with TRACE32 without GUI support. The resulting image does NOT require Qt/Motif.

## trace32-webtop
Image with TRACE32, GUI is drawn using a container local X-Server that is accessible using KasmVNC.
The image is based on [Linuxserver.io Webtop](https://docs.linuxserver.io/images/docker-webtop)

## trace32-with-container
Run TRACE32 within a Container but TRACE32 itself is stored on the host.

# X-Server related
The images *trace32-as-container* & *trace32-with-container* try to reuse the hosts X-Server domain socket.

By the time of writing the following variants exist to ensure the container get's access to the socket (Linux only).
## Simple
Allow all connections from the local user
```bash
xhost +SI:localuser:$(id -un)
```

## Mapping `.Xauthority`
Map the users `.Xauthority` file to `/tmp/Xauthority-host`
```bash
podman run \
  ... \
  --volume /tmp/.X11-unix:/tmp/.X11-unix --env DISPLAY \
  --volume ~/.Xauthority:/tmp/Xauthority-host:ro \
  ....
```

## `x11docker`
Use [x11docker](https://github.com/mviereck/x11docker) for X-Server handling
```bash
podman build ... --tag localhost/trace32 .
x11docker --backend podman localhost/trace32
```

# Author
Alexander Merkle