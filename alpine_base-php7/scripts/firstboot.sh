#!/bin/sh

# Check if uid and username are set
if [ -z ${APACHE_UID} ]; then
	export APACHE_UID='82'
fi

# Create user and change ownership of apache files
adduser -u $APACHE_UID -D -S -G www-data -H -h /var/www www-data
chown www-data:www-data -R /var/www/html
sed -i "s/User apache/User www-data/g" /etc/apache2/httpd.conf
sed -i "s/user = nobody/user = www-data/g" /etc/php7/php-fpm.d/www.conf
	
rm /etc/supervisor.d/00-firstboot.conf

supervisorctl restart apache
supervisorctl restart php-fpm