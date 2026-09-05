# Lightweight Nginx Image ব্যবহার করছি
FROM nginx:alpine

# আমাদের ওয়েবসাইটের সব ফাইল কন্টেইনারের Nginx ডিরেক্টরিতে কপি করা
COPY . /usr/share/nginx/html

# Expose Port 80 inside container
EXPOSE 80
