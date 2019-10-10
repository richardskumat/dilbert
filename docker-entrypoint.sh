#!/bin/bash
PUID=${PUID:-1000}
GUID=${GUID:-1000}
usermod -u ${PUID} user
groupmod -g ${GUID} user
chown user:user -R /home/user
su user -c "/home/user/dilbert ${@}"