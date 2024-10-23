# Use Python 3.11 as the base image
FROM python:3.11

# Set working directory
WORKDIR /srv

# Copy the script into the container
COPY ./podlib/podlib.sh /usr/local/bin/podlib

# Install necessary packages
# Install necessary packages
RUN pip install spotdl beets tidal-dl-ng sacad yt-dlp && \
    apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --fix-missing && \
    apt-get install -y imagemagick ffmpeg rsync && \
    chmod +x /usr/local/bin/podlib


# Define environment variables for music library and iPod mount
ENV MUSIC_LIBRARY="/music-library"
ENV IPOD_MOUNT="/ipod"

# Set the default command to run the script
CMD ["/srv/podlib.sh"]

