#!/bin/bash
echo "install plugin and setup wordpress ..."

update-alternatives --set php /usr/bin/php7.1

# broker Binder configurations
#ln -sf /var/www/html/Opus2Mortgage/public/favicon.ico /var/www/html/Opus2Mortgage/public/environment/favicon.ico
#ln -sf /var/www/html/Opus2Mortgage/public/assets/admin/layout4/css/themes/light.css /var/www/html/Opus2Mortgage/public/environment/custom.css
#ln -sf /var/www/html/Opus2Mortgage/public/assets/global/img/logo.png /var/www/html/Opus2Mortgage/public/environment/logo.png
# End broker Binder configurations

service php7.1-fpm start
service php7.4-fpm start
a2ensite homestead.test.conf
a2enconf phpmyadmin 
a2enmod rewrite


for varname in ${!DOCKER_*}
do
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.1/fpm/pool.d/www.conf
 echo "env[\"${varname}\"]=\"${!varname}\"" >> /etc/php/7.4/fpm/pool.d/www.conf
done

service php7.1-fpm restart
service php7.4-fpm restart
