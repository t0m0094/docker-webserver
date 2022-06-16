FROM alpine:3.16

# Update OS & install packages
RUN apk update && apk upgrade
RUN apk add supervisor bash bash-completion git composer apache2 php8 php8-apache2 php8-bcmath php8-ctype php8-curl php8-dom php8-exif php8-fileinfo php8-ftp php8-gd php8-iconv php8-pecl-imagick php8-intl php8-mbstring php8-pecl-mcrypt php8-mysqli php8-pdo_mysql php8-pdo_sqlite php8-phar php8-posix php8-session php8-simplexml php8-sockets php8-sodium php8-sqlite3 php8-tokenizer php8-pecl-ssh2 php8-xml php8-xmlreader php8-xmlwriter php8-zip


# Configure Apache
RUN sed -i 's|#LoadModule deflate_module modules/mod_deflate.so|LoadModule deflate_module modules/mod_deflate.so|g' /etc/apache2/httpd.conf
RUN sed -i 's|#LoadModule rewrite_module modules/mod_rewrite.so|LoadModule rewrite_module modules/mod_rewrite.so|g' /etc/apache2/httpd.conf

RUN sed -i 's|/var/www/localhost/htdocs|/var/www/html|g' /etc/apache2/httpd.conf
RUN sed -i 's|    Options Indexes FollowSymLinks|    Options FollowSymLinks|g' /etc/apache2/httpd.conf
RUN sed -i 's|    AllowOverride None|    AllowOverride All|g' /etc/apache2/httpd.conf
RUN sed -i 's|    ScriptAlias /cgi-bin/ "/var/www/localhost/cgi-bin/"|    #ScriptAlias /cgi-bin/ "/var/www/localhost/cgi-bin/"|g' /etc/apache2/httpd.conf

RUN sed -i 's|Group apache|Group www-data|g' /etc/apache2/httpd.conf

RUN sed -i 's|ServerTokens OS|ServerTokens Prod|g' /etc/apache2/httpd.conf
RUN sed -i 's|ServerSignature On|ServerSignature Off|g' /etc/apache2/httpd.conf

RUN rm /etc/apache2/conf.d/info.conf
RUN rm /etc/apache2/conf.d/userdir.conf

COPY etc/apache/deflate.conf /etc/apache2/conf.d/deflate.conf
COPY etc/apache/negotiation.conf /etc/apache2/conf.d/negotiation.conf
COPY etc/apache/mime.conf /etc/apache2/conf.d/mime.conf


# Create webroot
RUN mkdir -p /var/www/html
RUN rm -rf /var/www/localhost


# Configure php-fpm
RUN sed -i 's|expose_php = On|expose_php = Off|g' /etc/php8/php.ini
RUN sed -i 's|upload_max_filesize = 2M|upload_max_filesize = 64M|g' /etc/php8/php.ini
RUN sed -i 's|post_max_size = 8M|post_max_size = 64M|g' /etc/php8/php.ini
RUN sed -i 's|output_buffering = 4096|output_buffering = Off|g' /etc/php8/php.ini
RUN sed -i 's|;upload_tmp_dir =|upload_tmp_dir = /tmp|g' /etc/php8/php.ini


# Configure supervisord
RUN mkdir /etc/supervisor.d

COPY etc/supervisor/supervisord.conf /etc/supervisord.conf
COPY etc/supervisor/00-firstboot.conf /etc/supervisor.d/00-firstboot.conf
COPY etc/supervisor/01-apache.conf /etc/supervisor.d/01-apache.conf


# Copy startup script
RUN mkdir /scripts
COPY scripts/firstboot.sh /scripts/firstboot.sh
RUN chmod +x /scripts/firstboot.sh


# cleanup
RUN rm -rf /tmp/* /var/cache/apk/*


# start command
ENTRYPOINT ["supervisord"]