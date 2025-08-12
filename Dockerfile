FROM n8nio/n8n:latest

# Render يرسل رقم المنفذ في متغير PORT
ENV N8N_PORT=$PORT
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=Asia/Riyadh

# نخزن بيانات n8n هنا عشان ما تضيع
VOLUME ["/home/node/.n8n"]

CMD ["n8n", "start"]
