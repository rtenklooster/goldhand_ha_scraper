FROM node:23.10.0-bullseye

# Install git, jq AND all necessary libraries for Puppeteer/Chrome
RUN apt-get update && \
    apt-get install -y \
    git \
    jq \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    lsb-release \
    wget \
    xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Clone the universal scraper repo
RUN git clone https://github.com/rtenklooster/Universal-scraper-with-telegram-notifications.git .

# Create dummy .env for build
RUN echo "TELEGRAM_BOT_TOKEN=dummy\nDATABASE_TYPE=mssql\nDATABASE_PATH=/data/multiscraper.db" > .env

# Install backend dependencies
RUN npm install

# Build backend (nodig voor dist/index.js)
RUN npm run build

# Install frontend dependencies en build
WORKDIR /app/front-end
RUN npm install
RUN npm run build

# Return to app dir
WORKDIR /app

# Copy only the run script from local context
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose frontend port for ingress
EXPOSE 3000

CMD ["/run.sh"]
