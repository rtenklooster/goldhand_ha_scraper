#!/bin/bash
set -e

# Home Assistant config dir for persistent storage
CONFIG_DIR="/config/gh_universal_scraper"
mkdir -p "$CONFIG_DIR"

# Debug: toon inhoud van de data map met timestamps
if [ -d /data ]; then
  echo "[DEBUG] Inhoud van /data (bestand, aanmaakdatum, wijzigingsdatum):"
  ls -l --time=creation --time-style=long-iso /data || ls -l /data
else
  echo "[DEBUG] Map /data bestaat niet."
fi

# Read options from Home Assistant
OPTIONS_FILE="/data/options.json"
DB_URL=$(jq -r '.db_url' "$OPTIONS_FILE")
DOWNLOAD_DB=$(jq -r '.download_db' "$OPTIONS_FILE")
UPDATE_SOURCE=$(jq -r '.update_source' "$OPTIONS_FILE")
BOT_TOKEN=$(jq -r '.bot_token' "$OPTIONS_FILE")
DEFAULT_SCRAPE_INTERVAL_MINUTES=$(jq -r '.default_scrape_interval_minutes' "$OPTIONS_FILE")
DATABASE_TYPE=$(jq -r '.database_type' "$OPTIONS_FILE")
DATABASE_PATH=$(jq -r '.database_path' "$OPTIONS_FILE")
DATABASE_SERVER=$(jq -r '.database_server' "$OPTIONS_FILE")
DATABASE_NAME=$(jq -r '.database_name' "$OPTIONS_FILE")
DATABASE_USERNAME=$(jq -r '.database_username' "$OPTIONS_FILE")
DATABASE_PASSWORD=$(jq -r '.database_password' "$OPTIONS_FILE")
DATABASE_PORT=$(jq -r '.database_port' "$OPTIONS_FILE")
USE_ROTATING_PROXY=$(jq -r '.use_rotating_proxy' "$OPTIONS_FILE")
PROXY_URL=$(jq -r '.proxy_url' "$OPTIONS_FILE")
LOG_LEVEL=$(jq -r '.log_level' "$OPTIONS_FILE")
WEB_URL=$(jq -r '.web_url' "$OPTIONS_FILE")
ADMIN_TOKEN=$(jq -r '.admin_token' "$OPTIONS_FILE")

# Alleen backend builden bij update_source=true
if [ "$UPDATE_SOURCE" = "true" ]; then
  cd /app
  if [ -d .git ]; then
    echo "[DEBUG] Haal laatste code op van GitHub..."
    git pull origin main || echo "[DEBUG] git pull mislukt, ga verder met bestaande code."
    npm install
    npm run build
    cd /app/front-end
    npm install
    # GEEN npm run build meer hier
    cd /app
  else
    echo "[DEBUG] Geen .git directory gevonden, skip update."
  fi
else
  echo "[DEBUG] Source update/build is uitgeschakeld via configuratie."
fi

# Zet het database pad altijd absoluut in /data
if [[ "$DATABASE_PATH" = /* ]]; then
  ABS_DB_PATH="$DATABASE_PATH"
else
  ABS_DB_PATH="/data/$DATABASE_PATH"
fi

# Download DB if requested
if [ "$DOWNLOAD_DB" = "true" ] && [ -n "$DB_URL" ]; then
  echo "Downloading database from $DB_URL ..."
  DB_DIR=$(dirname "$ABS_DB_PATH")
  mkdir -p "$DB_DIR"
  curl -L "$DB_URL" -o "$ABS_DB_PATH"
fi

# Maak .env file aan voor de scraper
cat > .env <<EOF
TELEGRAM_BOT_TOKEN=$BOT_TOKEN
DEFAULT_SCRAPE_INTERVAL_MINUTES=$DEFAULT_SCRAPE_INTERVAL_MINUTES
DATABASE_TYPE=$DATABASE_TYPE
DATABASE_PATH=$ABS_DB_PATH
DATABASE_SERVER=$DATABASE_SERVER
DATABASE_NAME=$DATABASE_NAME
DATABASE_USERNAME=$DATABASE_USERNAME
DATABASE_PASSWORD=$DATABASE_PASSWORD
DATABASE_PORT=$DATABASE_PORT
USE_ROTATING_PROXY=$USE_ROTATING_PROXY
PROXY_URL=$PROXY_URL
LOG_LEVEL=$LOG_LEVEL
WEB_URL=$WEB_URL
ADMIN_TOKEN=$ADMIN_TOKEN
EOF

# Start backend (scraper) in background
npm start &

# Start frontend (npm)
cd /app/front-end
npm start
