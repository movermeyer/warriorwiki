FROM ubuntu:wily

# Configure apt
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu/ wily universe' >> /etc/apt/sources.list
RUN apt-get -y update

# Install prereqs
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor nginx-light php5-fpm php5-intl php5-mysql php5-
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y php-apc php5-gd php5-intl php5-mysqlnd php5-pgsql
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y git wget php5-cli imagemagick

#Install convenience apps
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y vim

# Add system service config
COPY  ./nginx.conf /etc/nginx/nginx.conf
COPY  ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY  ./fpm.conf /etc/php5/fpm/php-fpm.conf
COPY  ./fpm-pool-www.conf /etc/php5/fpm/pool.d/www.conf

# Add extension installation script
COPY ./mediawiki-extension-install /usr/bin/mediawiki-extension-install

# Add startup script
COPY  ./mediawiki-start /usr/bin/mediawiki-start

EXPOSE 80
EXPOSE 443

CMD /usr/bin/mediawiki-extension-install && /usr/bin/mediawiki-start