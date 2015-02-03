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

Deploy MySQL Docker container according to [their instructions.][docker-mysql]

    docker run --name mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql
    
Deploy the warriorwiki docker image and link it to the mysql container, and your data volume

    docker run -d -p 80:80 -v /usr/local/warriorwiki/data/:/data --link mysql:mysql --name=warriorwiki warriorwiki

Open port 80 to the outside world according to your firewall rules.

Success!

Visit your container on the internet!

###Next Steps

* Set up DNS
* Install proper SSL certificates


