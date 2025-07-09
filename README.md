# Universal Scraper Home Assistant Add-on

Deze add-on downloadt en start automatisch de Universal Scraper (met Telegram notificaties en web frontend) vanuit GitHub.

## Functionaliteit
- Downloadt optioneel een databasebestand vanaf een opgegeven URL.
- Start zowel de scraper (Python) als de front-end (npm start).
- Front-end is bereikbaar via Home Assistant ingress.
- Database wordt opgeslagen in de Home Assistant config map voor persistentie.
- Telegram bot token is instelbaar via de add-on configuratie.

## Configuratie
- `db_url`: (optioneel) URL naar het databasebestand.
- `download_db`: (boolean) Download de database bij starten.
- `bot_token`: Telegram bot token.

## Persistentie
De database wordt opgeslagen in `/config/universal_scraper/scraper.db`.

## Opstarten
Na installatie en configuratie start de add-on automatisch beide componenten.

## Bestanden
- `config.json`: Add-on configuratie
- `Dockerfile`: Build instructies
- `run.sh`: Startscript

## Ingress
De front-end is bereikbaar via het Home Assistant menu.
