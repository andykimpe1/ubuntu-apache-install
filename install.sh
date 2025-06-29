#!/bin/bash
VERSION=7.4
PORT=80
PORTSSL=443
read -e -p "Enter php mumber version 5.6 or 7.0 or 7.1 or 7.3 or 7.4 or 8.0 or 8.1 or 8.2 or 8.3: " -i "$VERSION" VERSION
read -e -p "Enter apache http port: " -i "$PORT" PORT
read -e -p "Enter apache https port: " -i "$PORTSSL" PORTSSL
apt-get update
apt-get -y install python-software-properties
apt-get -y install software-properties-common wget gnupg gnupg2
#apt-get -y purge php php*
add-apt-repository -y -s ppa:andykimpe/curl
add-apt-repository -y -s  ppa:ondrej/apache2
add-apt-repository -y -s  ppa:ondrej/php
apt-get update
apt-get -y dist-upgrade
apt-get -y install apache2 libapache2-mod-fcgid apache2-bin apache2-data apache2-utils php-pear
apt-get -y install libapache2-mod-php$VERSION php$VERSION php$VERSION-common php$VERSION-fpm
apt-get -y install php$VERSION-cli php$VERSION-mysql php$VERSION-gd php$VERSION-mcrypt php$VERSION-curl php$VERSION-imap php$VERSION-bz2 php$VERSION-zip
apt-get -y install php$VERSION-xmlrpc php$VERSION-xsl php$VERSION-intl php$VERSION-dev php$VERSION-mbstring
update-alternatives --set php /usr/bin/php$VERSION
update-alternatives --set phar /usr/bin/phar$VERSION
update-alternatives --set phar.phar /usr/bin/phar.phar$VERSION
update-alternatives --set phpize /usr/bin/phpize$VERSION
update-alternatives --set php-config /usr/bin/php-config$VERSION
update-alternatives --remove-all php-fpm
rm -f /usr/sbin/php-fpm
update-alternatives --install /usr/sbin/php-fpm php-fpm /usr/sbin/php-fpm$VERSION 10
update-alternatives --set php-fpm /usr/sbin/php-fpm$VERSION
a2dismod php5.6
a2dismod php7.0
a2dismod php7.1
a2dismod php7.2
a2dismod php7.3
a2dismod php7.4
a2dismod php8.0
a2dismod php8.1
a2dismod php8.2
a2dismod php8.3
a2dismod php8.4
a2enmod php$VERSION
phpenmod -v $VERSION mcrypt
phpenmod -v $VERSION mbstring
a2enmod rewrite
a2disconf php5.6-fpm
a2disconf php7.0-fpm
a2disconf php7.1-fpm
a2disconf php7.2-fpm
a2disconf php7.3-fpm
a2disconf php7.4-fpm
a2disconf php8.0-fpm
a2disconf php8.1-fpm
a2disconf php8.2-fpm
a2disconf php8.3-fpm
systemctl stop php$VERSION-fpm
systemctl disable php$VERSION-fpm
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/apache2.conf -O /etc/apache2/apache2.conf
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/ports.conf -O /etc/apache2/ports.conf
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/000-default.conf -O /etc/apache2/sites-available/000-default.conf
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/default-ssl.conf -O /etc/apache2/sites-available/default-ssl.conf
sed -i "s/8080/$PORT/g" "/etc/apache2/ports.conf"
sed -i "s/444/$PORTSSL/g" "/etc/apache2/ports.conf"
sed -i "s/8080/$PORT/g" "/etc/apache2/sites-available/000-default.conf"
sed -i "s/444/$PORTSSL/g" "/etc/apache2/sites-available/default-ssl.conf"
wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
tar -xzf ioncube_loaders_lin_x86-64.tar.gz -C /usr/local && rm -f ioncube_loaders_lin_x86-64.tar.gz
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/$VERSION/php.ini -O /etc/php/$VERSION/apache2/php.ini
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/$VERSION/php.ini -O /etc/php/$VERSION/cli/php.ini
wget https://raw.githubusercontent.com/andykimpe1/ubuntu-apache-install/master/$VERSION/php.ini -O /etc/php/$VERSION/fpm/php.ini
systemctl restart apache2
