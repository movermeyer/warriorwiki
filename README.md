[docker-mysql]: https://registry.hub.docker.com/_/mysql/
[warriorwiki]: http://warriorwiki.ca
##The Warrior Wiki

This is a repository for snippets of code that I change in order to customize [The Warrior Wiki][warriorwiki]

###Building the Docker Image

Clone the repo.

    git clone https://github.com/movermeyer/warriorwiki.git
    
Navigate to the 'docker' folder.

    cd warriorwiki/docker

Build the image.

    docker build --rm=true -t warriorwiki .
    
###Deploying the Docker Image

Clone my branch of mediawiki
    
    cd /usr/local/
    git clone https://github.com/movermeyer/mediawiki.git
    
Fetch a copy of the 'Vector' skin. Make sure that the skin matches the version of mediawiki in my branch

    cd /usr/local/mediawiki/skins
    wget https://extdist.wmflabs.org/dist/skins/Vector-REL1_24-4f17ccc.tar.gz Vector.tar.gz
    tar xvfz Vector.tar.gz

Deploy MySQL Docker container according to [their instructions.][docker-mysql]

    docker run --name mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql
    
Deploy the warriorwiki docker image and link it to the mysql container, and mount the mediawiki branch clone as a volume. Don't forget to specify the MySQL password as an environment variable.

    docker run -d -p 80:80 -v /usr/local/mediawiki:/src/mediawiki --link mysql:mysql -e MYSQL_PASSWORD="mysecretpassword" --name=warriorwiki warriorwiki

Open port 80 to the outside world according to your firewall rules.

Success!

Visit your container on the internet!

###Next Steps

* Set up DNS
* Install proper SSL certificates
* Set up non-priviledge MySQL user


