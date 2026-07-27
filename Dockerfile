FROM jrottenberg/ffmpeg:4.4-ubuntu

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y nginx curl

# Videoyu indir
RUN curl -L "https://docs.google.com/uc?export=download&id=1H0t1gwYJTOWw67gNbb33XHOCrfcwcpyi" -o /app/video1.mp4

# Logo ve Başlatma Betiğini Kopyala
COPY logo.png /app/logo.png
COPY entrypoint.sh /app/entrypoint.sh

# Nginx Ayarı ve Çalıştırma İzni
RUN echo 'server { listen 80; location / { root /var/www/html; add_header Access-Control-Allow-Origin *; } }' > /etc/nginx/sites-available/default && \
    mkdir -p /var/www/html/hls && \
    chmod +x /app/entrypoint.sh

# Betiği Çalıştır
CMD ["/app/entrypoint.sh"]
