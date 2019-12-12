FROM ljmict/phpfpm
LABEL author=ljmict email=ljmict@163.com
ENV NGINX_VERSION=1.16.1
RUN curl http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz \
    && tar xf /tmp/nginx-${NGINX_VERSION}.tar.gz -C /tmp && rm -f /tmp/nginx-${NGINX_VERSION}.tar.gz
WORKDIR /tmp/nginx-${NGINX_VERSION}
RUN yum install gcc pcre-devel openssl-devel zlib-devel -y && yum clean all \
    && useradd -r -s /sbin/nologin nginx \
    && ./configure --prefix=/apps/nginx-${NGINX_VERSION} \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --user=nginx --group=nginx \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_dav_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-file-aio \
    && make && make install && make clean
WORKDIR /apps/nginx-${NGINX_VERSION}
RUN rm -rf /tmp/nginx-${NGINX_VERSION} \
    && ln -s /apps/nginx-${NGINX_VERSION}/sbin/nginx /usr/local/bin/nginx
EXPOSE 80/tcp
ENTRYPOINT php-fpm && nginx -g "daemon off;"
