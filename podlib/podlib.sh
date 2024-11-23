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

# Function: list_music
list_music() {
  beet ls
}

# Function: initialize
initialize() {
  beet import -W -A "$MUSIC_LIBRARY"
}

# Function: get_covers
get_covers() {
  echo "Getting covers for the entire music library..."
  sacad_r "$MUSIC_LIBRARY" 500 "+" --convert-progressive-jpeg
}

# Function: sync_ipod
sync_ipod() {
  echo "Syncing music to your iPod..."
  rsync -av --no-owner --no-group --ignore-existing --exclude=".DS_Store" "${MUSIC_LIBRARY}/" "$IPOD_MOUNT"
}

# Function: detect_service
detect_service() {
  local url="$1"
  if [[ "$url" == *"spotify.com"* ]]; then
    echo "--spotify"
  elif [[ "$url" == *"youtube.com"* || "$url" == *"youtu.be"* ]]; then
    echo "--youtube"
  elif [[ "$url" == *"tidal.com"* ]]; then
    echo "--tidal"
  else
    echo "unknown"
  fi
}

# Function: download_music
download_music() {
  local service="$1"
  local url="$2"

  case "$service" in
  --spotify)
    echo "Downloading from Spotify..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    spotdl "$url" && beet -d "$MUSIC_LIBRARY" import . </dev/tty
    cd && rm -rf /tmp/musicdl
    sacad_r "$MUSIC_LIBRARY" 500 "+" --convert-progressive-jpeg
    ;;
  --youtube)
    echo "Downloading from YouTube..."
    mkdir /tmp/musicdl && cd /tmp/musicdl
    yt-dlp -x --audio-format mp3 "$url"
    beet -d "$MUSIC_LIBRARY" import . </dev/tty
    cd && rm -rf /tmp/musicdl
    sacad_r "$MUSIC_LIBRARY" 500 "+" --convert-progressive-jpeg
    ;;
  --tidal)
    echo "Downloading from Tidal..."
    tidal-dl-ng dl "$url" </dev/tty
    cd /tmp/tidal-downloads
    find . -type f -name '*.flac' -exec bash -c '
        file="$1"
        output="${file%.flac}.m4a"
        echo "Processing: $file"
        ffmpeg -y -i "$file" -vn -c:a alac -sample_fmt s16p -ar 44100 "$output"
        if [ $? -eq 0 ]; then
            rm "$file"
            echo "Successfully converted and deleted: $file"
        else
            echo "Conversion failed for: $file"
        fi
    ' _ {} \;
    beet -d "$MUSIC_LIBRARY" import /tmp/tidal-downloads </dev/tty
    rm -rf /tmp/tidal-downloads
    sacad_r "$MUSIC_LIBRARY" 500 "+" --convert-progressive-jpeg
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
ls)
  list_music
  ;;
init)
  initialize
  ;;
download)
  if [[ -n "$2" ]]; then
    if [[ "$2" == "--spotify" || "$2" == "--youtube" || "$2" == "--tidal" ]]; then
      download_music "$2" "$3"
    else
      # Automatically detect the service
      service=$(detect_service "$2")
      if [[ "$service" == "unknown" ]]; then
        echo "Unable to detect the service from the URL. Please specify manually."
      else
        download_music "$service" "$2"
      fi
    fi
  else
    echo "Usage: $0 download [--spotify|--youtube|--tidal] <URL>"
  fi
  ;;
*)
  echo "Usage: $0 {init|ls|import|get-covers|sync|download [--spotify|--youtube|--tidal] <URL>}"
  ;;
esac

