FROM ubuntu:20.04

# Define build arguments
ARG version="1.18.0"

# Install dependencies
RUN apt-get update \
&& apt-get install -y dialog apt-utils wget build-essential vim \
&& apt-get upgrade -y \
&& apt-get install -y libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev

# Created folder structure
RUN mkdir /etc/nginx \
&& mkdir /etc/nginx/conf.d \
&& mkdir /etc/nginx/sites-enabled \
&& mkdir /etc/nginx/streams-enabled \
&& mkdir /var/www \
&& mkdir /var/log/nginx

# Compile NGINX
RUN cd /tmp \
&& wget https://nginx.org/download/nginx-$version.tar.gz && tar zxf nginx-$version.tar.gz && cd nginx-$version \
&& ./configure \
--sbin-path=/usr/local/bin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/run/nginx.pid \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_ssl_preread_module \
&& make \
&& make install

# Copy over static files
COPY static/sites-available /etc/nginx/sites-available
COPY static/sites-enabled /etc/nginx/sites-enabled
COPY static/html /var/www/html
COPY static/nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx

EXPOSE 80/tcp
EXPOSE 443/tcp

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/streams-available", "/etc/nginx/ningx.conf"]

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
