#!/bin/bash

# Source podlib.conf
source $HOME/.config/podlib/podlib.conf

# Check if the iPod is mounted by searching the mount list
if mount | grep $PODLIB_IPOD_MOUNT >/dev/null; then
  # iPod is mounted; include the volume mount option
  docker compose -f $HOME/podlib/docker-compose.yml run --rm --remove-orphans -v $PODLIB_IPOD_MOUNT/Music:/ipod podlib podlib "$@"
else
  # iPod is not mounted; run without the volume mount
  echo "WARNING: Your iPod is not mounted or your mount path is incorrect! You wont be able to sync your music"
  docker compose -f $HOME/podlib/docker-compose.yml run --rm --remove-orphans podlib podlib "$@"
fi
