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
echo "---------------------------------------------------------------------"

sleep 1

MUSIC_LIBRARY="${MUSIC_LIBRARY:-/music-library}"
IPOD_MOUNT="${IPOD_MOUNT:-/ipod}"

# Function: import_music
import_music() {
  echo "Importing music into the library..."
  beet -d "$MUSIC_LIBRARY" import </dev/tty
}

# Function: get_covers
get_covers() {
  echo "Getting covers for the entire music library..."
  sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
  find "$MUSIC_LIBRARY" -name "cover.jpg" -exec convert {} -strip -interlace none {} \;
}

# Function: sync_ipod
sync_ipod() {
  echo "Syncing music to your iPod..."
  find "$MUSIC_LIBRARY" -name "cover.jpg" -exec convert {} -strip -interlace none {} \;
  rsync -av --ignore-existing --exclude=".DS_Store" "${MUSIC_LIBRARY}/" "$IPOD_MOUNT"
}

# Function: download_music
download_music() {
  local service="$1"
  local url="$2"

  case "$service" in
  --spotify)
    echo "Downloading from Spotify..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    cd /tmp/musicdl
    spotdl "$url" && beet -d "$MUSIC_LIBRARY" import . </dev/tty
    cd && rm -rf /tmp/musicdl
    sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
    ;;
  --youtube)
    echo "Downloading from YouTube..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    yt-dlp -x --audio-format mp3 "$url"

    # Import the music using beets
    beet -d "$MUSIC_LIBRARY" import . </dev/tty

    # Clean up the temporary directory
    cd && rm -rf /tmp/musicdl

    # Fetch cover art
    sacad_r "$MUSIC_LIBRARY" 500 cover.jpg
    ;;

  --tidal)
    echo "Downloading from Tidal..."
    tidal-dl-ng dl "$url" && beet -d "$MUSIC_LIBRARY" import /tmp/tidal-downloads </dev/tty
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
