#!/bin/bash
echo "
󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑
󰲑   _______  _______  ______   ___      ___   _______   󰲑
󰲑  |       ||       ||      | |   |    |   | |  _    |  󰲑
󰲑  |    _  ||   _   ||  _    ||   |    |   | | |_|   |  󰲑
󰲑  |   |_| ||  | |  || | |   ||   |    |   | |       |  󰲑
󰲑  |    ___||  |_|  || |_|   ||   |___ |   | |  _   |   󰲑
󰲑  |   |    |       ||       ||       ||   | | |_|   |  󰲑
󰲑  |___|    |_______||______| |_______||___| |_______|  󰲑
󰲑                                                       󰲑 
󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑 󰲑
"
echo "Your all-in-one music library manager, downloader, and iPod sync tool"

sleep 1

MUSIC_LIBRARY="${MUSIC_LIBRARY:-/music-library}"
IPOD_MOUNT="${IPOD_MOUNT:-/ipod}"

# Function: import_music
import_music() {
  echo "Importing music into the library..."
  beet -d "$MUSIC_LIBRARY" import
}

# Function: get_covers
get_covers() {
  echo "Getting covers for the entire music library..."
  sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
  find "$MUSIC_LIBRARY" -name "cover.jpg" -exec magick {} -strip -interlace none {} \;
}

# Function: sync_ipod
sync_ipod() {
  echo "Syncing music to your iPod..."
  rsync -av --ignore-existing --delete --exclude=".DS_Store" "$MUSIC_LIBRARY" "$IPOD_MOUNT"
}

# Function: download_music
download_music() {
  local service="$1"
  local url="$2"

  case "$service" in
  --spotify)
    echo "Downloading from Spotify..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    spotdl "$url" && beet -d "$MUSIC_LIBRARY" import .
    cd && rm -rf /tmp/musicdl
    sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
    ;;
  --youtube)
    echo "Downloading from YouTube..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    spotdl "$url" && beet -d "$MUSIC_LIBRARY" import .
    cd && rm -rf /tmp/musicdl
    sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
    ;;
  --tidal)
    echo "Downloading from Tidal..."
    tidal-dl-ng dl "$url" && beet -d "$MUSIC_LIBRARY" import /tmp/tidal-downloads
    rm -rf /tmp/tidal-downloads
    sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
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
