# Use Ubuntu as base image
FROM ubuntu:22.04

# Install nginx
RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

# Remove the default nginx index page
RUN rm -f /var/www/html/index.nginx-debian.html

# This executes when another image uses this as a base
ONBUILD COPY index.html /var/www/html/index.html

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]