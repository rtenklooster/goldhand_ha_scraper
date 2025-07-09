FROM node:20-bullseye

# Install Python and git
RUN apt-get update && \
    apt-get install -y python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Clone the universal scraper repo
RUN git clone https://github.com/rtenklooster/Universal-scraper-with-telegram-notifications.git .

# Install Python requirements
RUN pip3 install -r requirements.txt

# Install frontend dependencies
WORKDIR /app/front-end
RUN npm install

# Return to app dir
WORKDIR /app

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose frontend port for ingress
EXPOSE 3000

CMD ["/run.sh"]
