#!/bin/bash
echo "Running bash script"

update-alternatives --set php /usr/bin/php8.1
update-alternatives --install /usr/bin/python python /usr/bin/python3 10

service php7.1-fpm start
service php7.4-fpm start
service php8.1-fpm start
a2ensite performance-tracking.conf
a2ensite homestead.conf
a2ensite unique-properties.conf
a2ensite laravel-graphql.conf
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests
a2enconf phpmyadmin 
a2enmod rewrite


for varname in ${!DOCKER_*}
do
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.1/fpm/pool.d/www.conf
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.4/fpm/pool.d/www.conf
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/8.1/fpm/pool.d/www.conf
done

service php7.1-fpm restart
service php7.4-fpm restart
service php8.1-fpm restart
