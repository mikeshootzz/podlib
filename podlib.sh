#!/bin/bash

# Function: import_music
import_music() {
  echo "Importing music into the library..."
  beet import
}

# Function: get_covers
get_covers() {
  echo "Getting covers for the entire music library..."
  sacad_r ~/Music/Mike/ 500 cover.jpg
}

# Function: sync_ipod
sync_ipod() {
  echo "Syncing music to your iPod..."
  rsync -av --ignore-existing --delete --exclude=".DS_Store" ~/Music/Mike/ /Volumes/MIKE\'S\ IPOD/Music/
  find /Volumes/MIKE\'S\ IPOD/Music/ -name "cover.jpg" -exec magick {} -strip -interlace none {} \;
}

# Function: download_music
download_music() {
  local service="$1"
  local url="$2"

  case "$service" in
  --spotify)
    echo "Downloading from Spotify..."
    # Use spotdl to download from Spotify
    mkdir /tmp/musicdl
    cd /tmp/musicdl
    spotdl "$url" && beet import .
    cd
    rm -rf /tmp/musicdl
    sacad_r ~/Music/Mike/ 500 cover.jpg
    ;;
  --youtube)
    echo "Downloading from Spotify..."
    # Use spotdl to download from Spotify
    mkdir /tmp/musicdl
    cd /tmp/musicdl
    spotdl "$url" && beet import .
    cd
    rm -rf /tmp/musicdl
    sacad_r ~/Music/Mike/ 500 cover.jpg
    ;;
  --tidal)
    echo "Downloading from Tidal..."
    # Use Tidal Downloader NG or similar tool
    tidal-dl-ng dl "$url"
    beet import /Users/mike/Documents/Music
    rm -rf /Users/mike/Documents/Music/*
    sacad_r ~/Music/Mike/ 500 cover.jpg
    ;;
  *)
    echo "Invalid download service specified. Use --spotify, --youtube, or --tidal."
    ;;
  esac
}

# Main Script Logic
case "$1" in
import)
  import_music
  ;;
get-covers)
  get_covers
  ;;
sync)
  sync_ipod
  ;;
download)
  if [[ -n "$2" && -n "$3" ]]; then
    download_music "$2" "$3"
  else
    echo "Usage: $0 download --spotify|--youtube|--tidal <URL>"
  fi
  ;;
*)
  echo "Usage: $0 {import|get-covers|sync|download --spotify|--youtube|--tidal <URL>}"
  ;;
esac
