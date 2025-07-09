# Uploaden naar GitHub

Volg deze stappen om deze add-on naar je GitHub repository te uploaden:

1. Open een terminal in de map `/Users/richard/homeassistant-addon-scraper`.
2. Voer de volgende commando’s uit:

```sh
git init
git remote add origin https://github.com/rtenklooster/goldhand_ha_scraper.git
git add .
git commit -m "Initial commit: Goldhand Universal Scraper add-on"
git branch -M main
git push -u origin main
```

Hiermee wordt alles geüpload naar jouw GitHub repository.
