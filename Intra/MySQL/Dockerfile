FROM mysql:8.0

ENV http_proxy 'http://172.17.0.1:8087'
ENV https_proxy 'http://172.17.0.1:8087'
ENV HTTP_PROXY 'http://172.17.0.1:8087'
ENV HTTPS_PROXY 'http://172.17.0.1:8087'

# Write Permission
RUN usermod -u 1000 mysql && \
    chown mysql:mysql /var/run/mysqld/

EXPOSE 3306
VOLUME ["/opt"]


