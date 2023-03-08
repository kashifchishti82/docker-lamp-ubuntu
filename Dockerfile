FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-c"]

RUN \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update && apt-get install apache2 software-properties-common -y && \
  apt-get update -y && add-apt-repository ppa:ondrej/php -y && apt-get update -y && apt-get install -y libasound2 libatk1.0-0 libatspi2.0-0 libcairo2 libdrm2 libgbm1 wget unzip curl \
  libapache2-mod-wsgi-py3 fonts-liberation nano libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libu2f-udev libvulkan1 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils libapache2-mod-fcgid \
  php7.0 php7.0-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,bcmath,mongodb} \
  php7.1 php7.1-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,bcmath,mongodb} \
  php7.2 php7.2-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,bcmath,mongodb} \
  php7.3 php7.3-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,bcmath,mongodb} \
  php7.4 php7.4-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,bcmath,mongodb} \
  php8.0 php8.0-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,swoole,bcmath,mongodb} \
  php8.1 php8.1-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,swoole,bcmath,mongodb} \
  php8.2 php8.2-{fpm,common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,soap,zip,bcmath,intl,opcache,swoole,bcmath,mongodb} && \ 
  curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
  apt install -y nodejs && npm install -g yarn && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
  apt-get install -f -y && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i google-chrome*.deb && \
  curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php && HASH=`curl -sS https://composer.github.io/installer.sig` && \
  php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
  php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
  a2enmod proxy_fcgi setenvif wsgi && wget https://files.phpmyadmin.net/phpMyAdmin/5.2.0/phpMyAdmin-5.2.0-english.zip && \
  unzip phpMyAdmin-5.2.0-english.zip && mv phpMyAdmin-5.2.0-english /usr/share/phpmyadmin && \
  adduser www-data && usermod -a -G www-data root && chown -R www-data:www-data /var/www && \
  find /var/www -type d -exec chmod 2775 {} \; && find /var/www -type f -exec chmod 0664 {} \; && \
  mkdir /usr/share/phpmyadmin/tmp && chown -R www-data:www-data /usr/share/phpmyadmin && \
  chmod 777 /usr/share/phpmyadmin/tmp && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf /var/lib/apt/lists/*

COPY configurations/www-7.1.conf /etc/php/7.1/fpm/pool.d/www.conf
COPY configurations/www-7.4.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY configurations/php-7.1.ini /etc/php/7.1/fpm/php.ini
COPY configurations/phpmyadmin.conf /etc/apache2/conf-available/
COPY configurations/config.inc.php /usr/share/phpmyadmin/config.inc.php
COPY configurations/common.sh .
COPY sites-available/ /etc/apache2/sites-available/
RUN chmod +x common.sh && perl -pi -e 's/\r\n/\n/g' common.sh 


WORKDIR /var/www/html

EXPOSE 80 6001

CMD /common.sh && apachectl -DFOREGROUND
