#!/usr/bin/env sh
set -e

chown -R ${RED_USER}:${RED_USER} ${RED_HOME}/data

# Start Red launch script as specified user
exec runuser -u $RED_USER -- ${RED_HOME}/start-red.sh "$@"
