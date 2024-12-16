#!/bin/bash

warn () {
  local ORANGE NC
  ORANGE='\033[3;33m'
  NC='\033[0m'
  echo -e "${ORANGE}Warning:${NC} ${@}"
}

error () {
  local RED NC
  RED='\033[1;31m'
  NC='\033[0m'
  echo -e "${RED}Error:${NC} ${@}"
}

if [ -z ${DISPLAY} ]; then
  warn "Environment variable DISPLAY not set. Invoke podman/docker with '--env DISPLAY=\${DISPLAY}'"
fi

if [ ! -d /tmp/.X11-unix ]; then
  warn "Directory '/tmp/.X11-unix' missing. Invoke podman/docker with '--volume /tmp/.X11-unix:/tmp/.X11-unix'"
fi

if [ ! -d /opt/t32/bin/pc_linux64 ]; then
  error "Directory '/opt/t32' empty. Invoke podman/docker with '--volume <path to>:/opt/t32'"
  exit 1
fi

# process the hosts .Xauthority file mapped to /tmp/Xauthority-host (if exists)
source /usr/local/bin/xauthority-wildcard.sh

export PATH="/opt/t32/bin/pc_linux64:${PATH}"

exec ${@}
