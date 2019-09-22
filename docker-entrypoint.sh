#!/bin/bash
PUID=${PUID:-1000}
GUID=${GUID:-1000}
usermod -u ${PUID} user
groupmod -g ${GUID} user
chown user /dilbert /date-generator.py
chmod 0700 /dilbert /date-generator.py
chown user -R /home/user
su user -c "/dilbert ${@}"