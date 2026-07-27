#!/bin/bash

# Nginx web sunucusunu başlat
service nginx start

# FFmpeg canlı yayın döngüsü
ffmpeg -re -stream_loop -1 -i /app/video1.mp4 -i /app/logo.png \
  -filter_complex "[0:v][1:v]overlay=main_w-overlay_w-10:10" \
  -c:v libx264 -preset ultrafast -b:v 1500k \
  -c:a aac -b:a 128k \
  -f hls -hls_time 6 -hls_playlist_type event /var/www/html/yayin.m3u8
