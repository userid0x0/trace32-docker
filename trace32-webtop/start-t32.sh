#!/bin/bash
CURDIR=$(realpath $(dirname ${0}))

cd /t32work
exec ${T32SYS}/bin/pc_linux64/${T32EXE} ${@}
