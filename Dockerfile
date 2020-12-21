FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && apt-get -y dist-upgrade && apt-get update && \ 
  apt-get upgrade -y && apt-get install -y software-properties-common wget unzip && \
  add-apt-repository ppa:ondrej/php && apt-get install -y composer apache2 libapache2-mod-fcgid \
  php7.4-fpm php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick \
  php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring php7.4-soap php7.4-zip php7.4-bcmath php7.1-fpm \
  php7.1-common php7.1-mysql php7.1-xml php7.1-xmlrpc php7.1-curl php7.1-gd php7.1-imagick \ 
  php7.1-cli php7.1-dev php7.1-imap php7.1-mbstring php7.1-soap php7.1-zip php7.1-bcmath && \
  a2enmod proxy_fcgi setenvif && wget https://files.phpmyadmin.net/phpMyAdmin/5.0.3/phpMyAdmin-5.0.3-all-languages.zip && \
  unzip phpMyAdmin-5.0.3-all-languages.zip && mv phpMyAdmin-5.0.3-all-languages /usr/share/phpmyadmin && \
  adduser www-data && usermod -a -G www-data root && chown -R www-data:www-data /var/www && \
  find /var/www -type d -exec chmod 2775 {} \; && find /var/www -type f -exec chmod 0664 {} \; && \
  mkdir /usr/share/phpmyadmin/tmp && chown -R www-data:www-data /usr/share/phpmyadmin && \
  chmod 777 /usr/share/phpmyadmin/tmp && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

COPY configurations/www-7.1.conf /etc/php/7.1/fpm/pool.d/www.conf
COPY configurations/phpmyadmin.conf /etc/apache2/conf-available/
COPY configurations/config.inc.php /usr/share/phpmyadmin/config.inc.php
COPY configurations/common.sh /common.sh
RUN chmod +x /common.sh && a2enconf phpmyadmin



WORKDIR /var/www/html

EXPOSE 80

CMD /common.sh && apachectl -DFOREGROUND



   
