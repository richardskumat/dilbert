#!/bin/bash
set -x -eu -o pipefail
PUID=${PUID:-1000}
GUID=${GUID:-1000}
usermod -u ${PUID} user
groupmod -g ${GUID} user
chown user:user -R /home/user
su user -c "bash -x /home/user/dilbert ${@}"