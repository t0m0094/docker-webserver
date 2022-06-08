FROM alpine:3.15

# Update OS & install packages
RUN apk update && apk upgrade
RUN apk add supervisor bash bash-completion git composer apache2-proxy php7-fpm php7-bcmath php7-ctype php7-curl php7-dom php7-exif php7-fileinfo php7-ftp php7-gd php7-iconv php7-pecl-imagick php7-intl php7-json php7-mbstring php7-pecl-mcrypt php7-mysqli php7-pdo_mysql php7-pdo_sqlite php7-phar php7-posix php7-session php7-simplexml php7-sockets php7-sodium php7-sqlite3 php7-tokenizer php7-pecl-ssh2 php7-xml php7-xmlreader php7-xmlwriter php7-zip


# Configure Apache
RUN sed -i 's|#LoadModule mpm_event_module modules/mod_mpm_event.so|LoadModule mpm_event_module modules/mod_mpm_event.so|g' /etc/apache2/httpd.conf
RUN sed -i 's|LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so|g' /etc/apache2/httpd.conf
RUN sed -i 's|#LoadModule deflate_module modules/mod_deflate.so|LoadModule deflate_module modules/mod_deflate.so|g' /etc/apache2/httpd.conf
RUN sed -i 's|#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module modules/mod_rewrite.so|g' /etc/apache2/httpd.conf

RUN sed -i 's|/var/www/localhost/htdocs|/var/www/html|g' /etc/apache2/httpd.conf
RUN sed -i 's|    Options Indexes FollowSymLinks|    Options FollowSymLinks|g' /etc/apache2/httpd.conf
RUN sed -i 's|    AllowOverride None|    AllowOverride All|g' /etc/apache2/httpd.conf
RUN sed -i 's|    ScriptAlias /cgi-bin/ "/var/www/localhost/cgi-bin/"|    #ScriptAlias /cgi-bin/ "/var/www/localhost/cgi-bin/"|g' /etc/apache2/httpd.conf

RUN sed -i 's|Group apache|Group www-data|g' /etc/apache2/httpd.conf

RUN sed -i 's|ServerTokens OS|ServerTokens Prod|g' /etc/apache2/httpd.conf
RUN sed -i 's|ServerTokens OS|ServerTokens Prod|g' /etc/apache2/httpd.conf

RUN rm /etc/apache2/conf.d/info.conf
RUN rm /etc/apache2/conf.d/userdir.conf

COPY etc/apache/deflate.conf /etc/apache2/conf.d/deflate.conf
COPY etc/apache/negotiation.conf /etc/apache2/conf.d/negotiation.conf
COPY etc/apache/mime.conf /etc/apache2/conf.d/mime.conf


# Create webroot
RUN mkdir -p /var/www/html
RUN rm -rf /var/www/localhost


# Configure php-fpm
RUN echo '<FilesMatch \.php$>' > /etc/apache2/conf.d/php7-module.conf
RUN echo '    SetHandler "proxy:fcgi://127.0.0.1:9000"' >> /etc/apache2/conf.d/php7-module.conf
RUN echo '</FilesMatch>' >> /etc/apache2/conf.d/php7-module.conf
RUN echo 'DirectoryIndex index.html index.htm index.php' >> /etc/apache2/conf.d/php7-module.conf

RUN sed -i 's|expose_php = On|expose_php = Off|g' /etc/php7/php.ini
RUN sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php7/php.ini
RUN sed -i 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php7/php.ini
RUN sed -i 's|output_buffering = 4096|output_buffering = Off|g' /etc/php7/php.ini
RUN sed -i 's|;upload_tmp_dir =|upload_tmp_dir = /tmp|g' /etc/php7/php.ini


RUN sed -i 's|group = nobody|group = www-data|g' /etc/php7/php-fpm.d/www.conf
RUN mkdir /var/run/php


# Configure supervisord
RUN mkdir /etc/supervisor.d

COPY etc/supervisor/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor/00-firstboot.conf /etc/supervisor.d/00-firstboot.conf
COPY etc/supervisor/01-apache.conf /etc/supervisor.d/01-apache.conf
COPY etc/supervisor/02-php-fpm.conf /etc/supervisor.d/02-php-fpm.conf


# Copy startup script
RUN mkdir /scripts
COPY scripts/firstboot.sh /scripts/firstboot.sh
RUN chmod +x /scripts/firstboot.sh


# cleanup
RUN rm -rf /tmp/* /var/cache/apk/*


# start command
ENTRYPOINT ["supervisord"]