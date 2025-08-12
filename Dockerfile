FROM n8nio/n8n:latest
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=Asia/Riyadh
VOLUME ["/home/node/.n8n"]
