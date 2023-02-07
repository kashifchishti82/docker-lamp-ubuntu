FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN \
  rm -rf /var/lib/apt/lists/* && \
  apt-get update && apt-get install apache2 software-properties-common -y && \
  apt update && add-apt-repository ppa:ondrej/php -y && apt-get update && \
  apt-get install -y fonts-liberation  libapache2-mod-fcgid wget unzip curl php7.4-fpm php7.4-common php7.4-mysql php7.4-xml libapache2-mod-wsgi-py3 \
  libatk-bridge2.0-0 libasound2 libatk1.0-0 libatspi2.0-0 libcairo2 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libu2f-udev \
  libvulkan1 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils \
  php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-dev php7.4-imap php7.4-mbstring \
  php7.4-soap php7.4-zip php7.4-bcmath php7.4-intl php8.1-fpm php8.1-common php8.1-mysql php8.1-xml \
  php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-dev php8.1-imap php8.1-mbstring \
  php8.1-soap php8.1-zip php8.1-bcmath php8.1-intl php8.1-swoole php7.1-fpm php7.1-common php7.1-mysql \
  php7.1-xml php7.1-xmlrpc php7.1-curl php7.1-gd php7.1-imagick php7.1-intl php7.1-cli php7.1-dev php7.1-imap \
  php7.1-mbstring php7.1-soap php7.1-zip php7.1-bcmath && curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
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

EXPOSE 80

CMD /common.sh && apachectl -DFOREGROUND