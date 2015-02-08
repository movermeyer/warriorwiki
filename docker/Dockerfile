from	ubuntu:latest

# Configure apt
run	echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list
run	apt-get -y update

# Install prereqs
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor nginx-light php5-fpm php5-intl php5-mysql php5-
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y php-apc php5-gd php5-intl php5-mysqlnd php5-pgsql
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y git wget php5-cli

#Install convenience apps
run	LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y vim

# Add system service config
add	./nginx.conf /etc/nginx/nginx.conf
add	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
add	./fpm.conf /etc/php5/fpm/php-fpm.conf
add	./fpm-pool-www.conf /etc/php5/fpm/pool.d/www.conf

# Add extension installation script
add ./mediawiki-extension-install /usr/bin/mediawiki-extension-install

# Add startup script
add	./mediawiki-start /usr/bin/mediawiki-start

expose	80
expose	443

cmd	["/bin/bash"] #/usr/bin/mediawiki-extension-install && /usr/bin/mediawiki-start

# vim:ts=8:noet:
