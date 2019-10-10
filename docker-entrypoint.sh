#!/bin/bash
PUID=${PUID:-1000}
GUID=${GUID:-1000}
usermod -u ${PUID} user
groupmod -g ${GUID} user
cd /home/user
chmod 0700 dilbert date-generator.py
chown user:user -R /home/user
su user -c "/home/user/dilbert ${@}"