#!/bin/bash
set -e

# Home Assistant config dir for persistent storage
CONFIG_DIR="/config/universal_scraper"
mkdir -p "$CONFIG_DIR"

# Read options from Home Assistant
OPTIONS_FILE="/data/options.json"
DB_URL=$(jq -r '.db_url' "$OPTIONS_FILE")
DOWNLOAD_DB=$(jq -r '.download_db' "$OPTIONS_FILE")
BOT_TOKEN=$(jq -r '.bot_token' "$OPTIONS_FILE")

# Download DB if requested
if [ "$DOWNLOAD_DB" = "true" ] && [ -n "$DB_URL" ]; then
  echo "Downloading database from $DB_URL ..."
  curl -L "$DB_URL" -o "$CONFIG_DIR/scraper.db"
fi

# Symlink database to expected location
ln -sf "$CONFIG_DIR/scraper.db" /app/scraper.db

# Set bot token as env var
export BOT_TOKEN="$BOT_TOKEN"

# Start backend (Python scraper) in background
python3 main.py &

# Start frontend (npm)
cd /app/front-end
npm start
