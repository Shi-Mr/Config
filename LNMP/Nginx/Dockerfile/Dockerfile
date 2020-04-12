FROM ubuntu:18.04
MAINTAINER shiqingsheng <shi_work@126.com>

WORKDIR /etc/apt
ADD Source/ /opt/soft

RUN mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN apt-get install \
        perl \
        dpkg-dev \
        build-essential \
        libc-dev \
        wget \
        bzip2 \
        curl \
        wget \
        software-properties-common \
        libxml2 \
        libxml2-dev \
        libevent-1.4-2 \
        libevent-dev \
        make \
	libcurl4 \
        libcurl4-gnutls-dev \
        g++ \
        libmcrypt4 \
        libmcrypt-dev  \
        libssl-dev \
        openssl autoconf -y
    
#gd
RUN mkdir -p /opt/build && \
     tar zxf /opt/soft/nginx-1.16.1.tar.gz -C /opt/build && \
     tar zxf /opt/soft/pcre-8.44.tar.gz -C /opt/build && \
     tar zxf /opt/soft/zlib-1.2.11.tar.gz -C /opt/build

WORKDIR /opt/build/nginx-1.16.1
RUN ./configure  \       
    --sbin-path=/etc/nginx/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --with-http_ssl_module \
    --with-pcre=/opt/build/pcre-8.44 \
    --with-zlib=/opt/build/zlib-1.2.11 && \
     make && make install

ARG user=www
ARG group=www
ARG uid=1000
ARG gid=1000

#添加用户
RUN groupadd -g ${gid} ${group} \
    && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN usermod -u 1000 www

ADD ./Source/nginx.conf /etc/nginx/nginx.conf

WORKDIR /

RUN mkdir www

RUN echo '#!/bin/bash' > /init.sh && \
    echo '/etc/nginx/nginx -g "daemon off;"' >> /init.sh && \
    chmod +x /init.sh && \
    chown -R www:www /www

RUN rm -rf /opt/soft  /opt/build && \
    apt-get autoremove && \
    apt-get autoclean

CMD ["/init.sh"]
EXPOSE 80
VOLUME ["/www"]

