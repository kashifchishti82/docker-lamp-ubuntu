#!/bin/bash
echo "install plugin and setup wordpress ..."

service php7.1-fpm start
service php7.4-fpm start
a2ensite homestead.test.conf

for varname in ${!DOCKER_*}
do
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.1/fpm/pool.d/www.conf
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.4/fpm/pool.d/www.conf
done
service php7.1-fpm restart
service php7.4-fpm restart
