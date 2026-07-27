FROM jrottenberg/ffmpeg:4.4-ubuntu

WORKDIR /app

# Soru sormasını engelle ve paketleri kur
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y nginx python3-pip

RUN pip3 install gdown

# Drive onay ekranını geçen fuzzy parametreli gdown komutu
RUN gdown --fuzzy "https://drive.google.com/uc?id=1H0t1gwYJTOWw67gNbb33XHOCrfcwcpyi" -O /app/video1.mp4

# Logoyu kopyala
COPY logo.png /app/logo.png

# Web Sunucusu (Nginx) Ayarı
RUN echo 'server { listen 80; location / { root /var/www/html; add_header Access-Control-Allow-Origin *; } }' > /etc/nginx/sites-available/default
RUN mkdir -p /var/www/html/hls

# Yayını Başlat
CMD ["sh", "-c", "service nginx start && ffmpeg -re -stream_loop -1 -i /app/video1.mp4 -i /app/logo.png -filter_complex '[0:v][1:v]overlay=main_w-overlay_w-10:10' -c:v libx264 -preset ultrafast -b:v 1500k -c:a aac -b:a 128k -f hls -hls_time 6 -hls_playlist_type event /var/www/html/yayin.m3u8"]
