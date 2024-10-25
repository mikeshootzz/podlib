# podlib

**⚠️ DISCLAIMER**
This tool is intended for personal use only with music that you *already legally own.* Unauthorized distribution or downloading of copyrighted music without permission is illegal and could result in legal consequences. The creator of this tool is not responsible for any misuse or consequences arising from its use. By using this tool, you agree to comply with all applicable laws and assume full responsibility for any risks associated with its usage.

---

## Overview

podlib is a comprehensive tool for managing your music library, supporting tasks like downloading, organizing, and syncing music files. With an integrated CLI interface, it allows you to access and control your music collection seamlessly, making it easy to maintain a tidy library and enjoy your music on devices like an iPod.

## Features

- **Music Downloading:** Supports downloading tracks from supported platforms (YouTube, Spotify, Tidal) for music you legally own.
- **Library Management:** Organize and tag music files for easy access and sorting.
- **Album Art Fetching:** Retrieves album artwork to keep your library visually organized.
- **Sync with iPod:** Syncs your library directly with Rockbox-compatible iPods, using `rsync` for efficient updates.

## Installation

To install podlib, run the following command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/mikeshootzz/podlib/refs/heads/main/install.sh | bash
```

Next, set the iPod mount Path in `~/.config/podlib/podlib.conf`

```env
PODLIB_IPOD_MOUNT=/Volumes/IPOD
```

Make sure to not include a trailing slash in the path.

## Usage

Once installed, start the podlib CLI by running:

```bash
podlib
```

### Options

| Command                         | Description                                                                                         |
|---------------------------------|-----------------------------------------------------------------------------------------------------|
| `init`                          | Initializes the music library by importing all existing music in the specified library folder.      |
| `ls`                            | Lists all songs in the music library.                                                               |
| `import`                        | Imports new music files into the library and adds metadata using Beets.                             |
| `get-covers`                    | Downloads and embeds cover art for all songs in the library.                                        |
| `sync`                          | Syncs the music library with your iPod at the specified mount point.                                |
| `download --spotify <URL>`      | Downloads a song from Spotify and adds it to the library.                                           |
| `download --youtube <URL>`      | Downloads a song from YouTube as an MP3 and adds it to the library.                                 |
| `download --tidal <URL>`        | Downloads a song from Tidal and adds it to the library.                                             |

## Requirements

- **Docker**: Everything runs on docker!

## Configuration

podlib stores configuration files in `~/.config/podlib`. You can modify these files to customize download paths, preferred platforms, and metadata settings.

## Contributing

Contributions are welcome! If you'd like to improve podlib, feel free to open an issue or submit a pull request on the [GitHub repository](https://github.com/mikeshootzz/podlib).
