#!/bin/bash

warn () {
  local ORANGE NC
  ORANGE='\033[3;31m'
  NC='\033[0m'
  echo -e "${ORANGE}Warning:${NC} ${@}"
}

if [ -z ${DISPLAY} ]; then
  warn "Environment variable DISPLAY not set. Invoke podman/docker with '--env DISPLAY=\${DISPLAY}'"
fi

if [ ! -d /tmp/.X11-unix ]; then
  warn "Directory '/tmp/.X11-unix' missing. Invoke podman/docker with '--volume /tmp/.X11-unix:/tmp/.X11-unix'"
fi

exec ${@}