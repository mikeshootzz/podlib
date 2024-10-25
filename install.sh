#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define variables
REPO_URL="https://github.com/mikeshootzz/podlib.git"
CLONE_DIR="$HOME/podlib"
CONFIG_DIR="$HOME/.config/podlib"

# Clone the repository into the user's home directory
if [ -d "$CLONE_DIR" ]; then
  echo "Directory $CLONE_DIR already exists. Pulling latest changes..."
  git -C "$CLONE_DIR" pull
  docker compose -f "$CLONE_DIR/docker-compose.yml" pull
else
  echo "Cloning repository into $CLONE_DIR..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi

# Copy run.sh to /usr/local/bin as 'podlib' with sudo
echo "Copying run.sh to /usr/local/bin/podlib..."
sudo cp "$CLONE_DIR/run.sh" /usr/local/bin/podlib
sudo chmod +x /usr/local/bin/podlib

# Create the config directory and copy the contents
echo "Creating config directory at $CONFIG_DIR..."
mkdir -p "$CONFIG_DIR"

echo "Copying config files to $CONFIG_DIR..."
cp -r "$CLONE_DIR/config/." "$CONFIG_DIR/"

echo "Installation complete. You can now run 'podlib' from the command line."
