from	ubuntu:latest

# Configure apt
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
run	apt-get -y update

# Install prereqs
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor nginx-light php5-fpm php5-intl php5-mysql php5-
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y php-apc php5-gd php5-intl php5-mysqlnd php5-pgsql
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y git

#Install convenience apps
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y vim

# Add system service config
add	./nginx.conf /etc/nginx/nginx.conf
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
add	./fpm.conf /etc/php5/fpm/php-fpm.conf
add	./fpm-pool-www.conf /etc/php5/fpm/pool.d/www.conf

# Install mediawiki
run	mkdir /src
add	https://releases.wikimedia.org/mediawiki/1.24/mediawiki-1.24.1.tar.gz /src/mediawiki.tgz
run	cd /src && tar zxf mediawiki.tgz
run	ln -snf /src/mediawiki-1.24.1 /src/mediawiki
run	chown -R www-data:www-data /src/mediawiki/

# Add data directory and symlinks that can then be used as a data volume
run	mkdir /data
run	ln -s /data/LocalSettings.php /src/mediawiki/LocalSettings.php
run	rm -rf /src/mediawiki/images
run	ln -s /data/images /src/mediawiki/images

# Add startup script
add	./mediawiki-start /usr/bin/mediawiki-start

#Install wikidata
run	cd /src/mediawiki/ && \
LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y wget php5-cli && \
wget https://getcomposer.org/installer && \
php installer && \
cd /src/mediawiki/extensions && \
git clone https://git.wikimedia.org/git/mediawiki/extensions/Wikibase.git && \
cd Wikibase && \
php /src/mediawiki/composer.phar install && \
cd /src/mediawiki/ && \
php maintenance/update.php --quick && \
php maintenance/runScript.php extensions/Wikibase/lib/maintenance/populateSitesTable.php && \
php maintenance/runScript.php extensions/Wikibase/client/maintenance/populateInterwiki.php


expose	80
cmd	["/bin/bash"] #/usr/bin/mediawiki-start

# vim:ts=8:noet:
