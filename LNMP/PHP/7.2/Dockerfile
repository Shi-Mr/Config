FROM ubuntu:18.04
MAINTAINER shiqingsheng<shi_work@126.com>

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /etc/apt
ADD Source/ /opt/soft

Run mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN  apt-get install build-essential  -y

RUN apt-get install \
        curl \
        wget \
        git \
        bison \
        libicu-dev \
        libmemcached-dev \
        libzip-dev \
        libc6-dev \
        dpkg-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        libmcrypt-dev \
        libxml2-dev \
        libbz2-dev \
        libxslt-dev \
        libmysqlclient-dev \
        libxpm-dev \
        autoconf \
        openssl \
        libcurl4-openssl-dev \
        libldap2-dev \
        cron vim openssh-server -y

RUN  mkdir -p /opt/build
WORKDIR /opt/build

ARG user=shi
ARG group=shi
ARG uid=1000
ARG gid=1000

#添加用户
RUN groupadd -g ${gid} ${group} \
    && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

#sudo
RUN echo "shi:shi"|chpasswd
RUN echo "shi   ALL=(ALL)       ALL" >> /etc/sudoers

RUN tar zxf /opt/soft/php-7.2.29.tar.gz -C /opt/build

WORKDIR /opt/build/php-7.2.29

RUN ./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-libdir=lib64 \
    --enable-mbstring \
    --with-curl \
    --with-openssl \
    --with-xmlrpc \
    --enable-soap \
    --enable-zip \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --enable-embedded-mysqli \
    --with-freetype-dir \
    --enable-intl \
    --with-xsl \
    --enable-fpm \
    --without-pear \
    --disable-phar \
    --with-fpm-user=shi \
    --with-fpm-group=shi &&\
    make && make install 

RUN \
    cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && \
    chmod +x /etc/init.d/php-fpm && \
    mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
    cp /opt/build/php-7.2.29/php.ini-production /usr/local/php/etc/php.ini && \
    ln -sf /usr/local/php/bin/php /usr/bin/php && \
    ln -sf /usr/local/php/bin/php-config /usr/bin/php-config && \
    ln -sf /usr/local/php/bin/phpize /usr/bin/phpize && \
    head -n 937 /opt/build/php-7.2.29/php.ini-production > /usr/local/php/etc/php.ini && \
    tail -n+1000 /opt/build/php-7.2.29/php.ini-production >> /usr/local/php/etc/php.ini && \
    echo 'detect_unicode = Off' >> /usr/local/php/etc/php.ini

RUN \
    sed -i 's/max_input_time = 30/max_input_time = 60/g' /usr/local/php/etc/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = 60/g' /usr/local/php/etc/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /usr/local/php/etc/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /usr/local/php/etc/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /usr/local/php/etc/php.ini && \
    sed -i 's@;date.timezone =@date.timezone = "Europe/Moscow"@g' /usr/local/php/etc/php.ini && \
    sed -i 's/pm.max_children = 5/pm.max_children = 8/g' /usr/local/php/etc/php-fpm.conf && \
    sed -i 's@;pm.status_path = /status@pm.status_path = /fpm-status@g' /usr/local/php/etc/php-fpm.conf && \
    sed -i 's@;ping.path = /ping@ping.path = /fpm-ping@g' /usr/local/php/etc/php-fpm.conf && \
    sed -i 's@127.0.0.1:9000@0.0.0.0:9000@g' /usr/local/php/etc/php-fpm.conf && \
    cp /usr/local/php/etc/php-fpm.d/www.conf.default  /usr/local/php/etc/php-fpm.d/www.conf &&\
    sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /usr/local/php/etc/php-fpm.d/www.conf

# Install Xdebug
RUN set -x \
    && mkdir -p /usr/src/xdebug \
    && tar zxf /opt/soft/xdebug-2.9.4.tgz -C /usr/src/xdebug --strip-components=1 \
    && cd /usr/src/xdebug \
    && phpize \
    && ./configure \
    && make -j"$(nproc)" \
    && make install \
    && cp /usr/src/xdebug/modules/xdebug.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20170718/ \
    && make clean 

RUN  \
     echo 'zend_extension=/usr/local/php/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.remote_enable = on' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.remote_handler=dbgp' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.remote_host=172.17.0.1' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.remote_port=9000' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.profiler_enable = off' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.profiler_enable_trigger = off' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.profiler_output_name = cachegrind.out.%t.%pc' >> /usr/local/php/etc/php.ini && \
     echo 'xdebug.idekey=PHPSTORM' >> /usr/local/php/etc/php.ini 


#install composer
RUN mv /opt/soft/composer.phar   /usr/bin/composer

RUN usermod -u 1000 shi

#configure timezone
RUN apt-get install -y ntp && ntpd -gq && service ntp start

RUN echo Asia/Shanghai >/etc/timezone && \
           dpkg-reconfigure -f noninteractive tzdata 

# Define working directory.
WORKDIR /
RUN echo '#!/bin/bash' > /init.sh && \
    echo '/etc/init.d/php-fpm restart' >> /init.sh && \
    echo 'sudo su shi' && \
    echo 'tail -f /usr/local/php/var/log/php-fpm.log' >> /init.sh && \
    chmod 777 /init.sh

#ssh service
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo "root:root" | chpasswd
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers

RUN apt-get autoclean  && \
    apt-get clean  && \
    apt-get autoremove && \
    rm -rf /opt/  /tmp/

CMD ["/init.sh"]
# Expose ports.
VOLUME ["/opt"]
EXPOSE 9000 22

