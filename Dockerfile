FROM ubuntu:latest

# Environment variables
ENV PUFFER_PANEL_PORT=2090
ENV ADMIN_USERNAME=chirag
ENV ADMIN_PASSWORD=chirag
ENV ADMIN_EMAIL=chirag@chirag

# Install dependencies and PufferPanel
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget git python3 && \
    curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && \
    apt-get install -y pufferpanel

# Download systemctl3.py and set permissions
RUN curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py && \
    chmod -R 777 /bin/systemctl

# Set PufferPanel port
RUN sed -i "s/\"host\": \"0.0.0.0:8080\"/\"host\": \"0.0.0.0:${PUFFER_PANEL_PORT}\"/g" /etc/pufferpanel/config.json

# Create admin user
RUN pufferpanel user add --name "${ADMIN_USERNAME}" --password "${ADMIN_PASSWORD}" --email "${ADMIN_EMAIL}" --admin

# Expose the PufferPanel port
EXPOSE ${PUFFER_PANEL_PORT}

# Restart PufferPanel
CMD systemctl restart pufferpanel
