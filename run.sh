#!/bin/bash

# Check if the iPod is mounted by searching the mount list
if mount | grep '/Volumes/IPOD' >/dev/null; then
  # iPod is mounted; include the volume mount option
  docker compose -f $HOME/podlib/docker-compose.yml run --rm --remove-orphans -v /Volumes/IPOD/Music:/ipod podlib podlib "$@"
else
  # iPod is not mounted; run without the volume mount
  echo "WARNING: Your iPod is not mounted or your mount path is incorrect! You wont be able to sync your music"
  docker compose -f $HOME/podlib/docker-compose.yml run --rm --remove-orphans podlib podlib "$@"
fi
