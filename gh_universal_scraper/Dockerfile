FROM node:20-bullseye

# Install git and jq
RUN apt-get update && \
    apt-get install -y git jq && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Clone the universal scraper repo
RUN git clone https://github.com/rtenklooster/Universal-scraper-with-telegram-notifications.git .

# Install backend dependencies
RUN npm install

# Build backend (nodig voor dist/index.js)
RUN npm run build

# Install frontend dependencies
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
