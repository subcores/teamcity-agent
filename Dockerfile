FROM jetbrains/teamcity-minimal-agent:latest

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt update && apt upgrade -y

RUN apt install software-properties-common -y
RUN apt install -y unzip
RUN apt install -y curl
RUN apt install -y git
RUN apt install -y sudo
RUN apt install -y sshpass


RUN add-apt-repository ppa:ondrej/php
RUN apt update
#RUN apt install -y libnode72

RUN mkdir /root/.ssh
RUN echo "Host *\n    StrictHostKeyChecking no" > /root/.ssh/config -e

RUN apt install -y php8.2-dev php8.2-cli php8.2-curl php8.2-xml php8.2-gd php8.2-imagick php8.2-zip php8.2-mysql php8.2-sqlite3 php8.2-pgsql php8.2-intl php8.2-mbstring php8.2-ctype php8.2-redis php8.2-apcu php8.2-imap php8.2-http php8.2-xsl

# Composer
RUN curl -sS https://getcomposer.org/installer -o composer-installer.php
RUN php composer-installer.php --install-dir=/usr/local/bin --filename=composer
RUN rm -f composer-installer.php

RUN composer global require 'phpunit/phpunit=^9' 'phpunit/php-code-coverage=^9' 'phpmd/phpmd=^2.11' 'pdepend/pdepend=^2.10' 'sebastian/phpcpd=^6.0' 'phploc/phploc=^7.0' 'squizlabs/php_codesniffer=^3.6' 'phpstan/phpstan=^1.8'\
    && ln -s ~/.composer/vendor/bin/phpunit /usr/local/bin/phpunit \
    && ln -s ~/.composer/vendor/bin/phpcpd /usr/local/bin/phpcpd \
    && ln -s ~/.composer/vendor/bin/phploc /usr/local/bin/phploc \
    && ln -s ~/.composer/vendor/bin/phpmd /usr/local/bin/phpmd \
    && ln -s ~/.composer/vendor/bin/pdepend /usr/local/bin/pdepend \
    && ln -s ~/.composer/vendor/bin/phpcs /usr/local/bin/phpcs \
    && ln -s ~/.composer/vendor/bin/phpstan /usr/local/bin/phpstan

# Symfony CLI
#RUN wget https://get.symfony.com/cli/installer -O - | bash
#RUN mv ~/.symfony/bin/symfony /usr/local/bin/symfony

# Nodejs
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN rm nodesource_setup.sh
RUN apt install -y nodejs
RUN npm install -g n
RUN npm install -g yarn
RUN n lts

# cleanup
RUN rm -rf /var/lib/apt/lists/*

