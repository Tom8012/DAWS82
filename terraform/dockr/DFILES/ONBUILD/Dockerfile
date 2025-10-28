# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install nginx and clean up apt cache to reduce image size
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# Remove the default nginx index page
RUN rm -f /var/www/html/index.nginx-debian.html

# Copy index.html for standalone use
COPY index.html /var/www/html/index.html

# This executes if another Dockerfile uses this image as its base
ONBUILD COPY index.html /var/www/html/index.html

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]