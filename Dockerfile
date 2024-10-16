# Use Python 3.11 as the base image
FROM python:3.11

# Set working directory
WORKDIR /srv

# Copy the script into the container
COPY podlib.sh /srv/podlib.sh

# Install necessary packages
RUN pip install spotdl beets tidal-dl-ng && \
    apt-get update && \
    apt-get install -y imagemagick && \
    chmod +x /srv/podlib.sh

# Define environment variables for music library and iPod mount
ENV MUSIC_LIBRARY /music-library
ENV IPOD_MOUNT /ipod

# Set the default command to run the script
CMD ["/srv/podlib.sh"]

