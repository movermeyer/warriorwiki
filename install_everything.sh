BASE_DIR='/usr/local/warriorwiki'
DATA_DIR='/usr/local/data'
MW_DIR='/usr/local/mediawiki'

GIT_REPO='https://github.com/movermeyer/warriorwiki.git'
MW_REPO='https://github.com/movermeyer/mediawiki.git'

DNS_NAME='warriorwiki.ca'
FILES_SUBDOMAIN=files.${DNS_NAME}

DATABASE_NAME='warriorwiki'
DATABASE_DIR=$DATA_DIR/db

MYSQL_PREVIOUS_BACKUP=$1
MYSQL_PREVIOUS_BACKUP_DIR=dirname $MYSQL_PREVIOUS_BACKUP
MYSQL_PREVIOUS_BACKUP_FILE=basename $MYSQL_PREVIOUS_BACKUP

IMAGES_DIR=${DATA_DIR}/${FILES_SUBDOMAIN}

PRIVATE_DIR=${BASE_DIR}/private

SSL_CERT_DIR='/etc/ssl/localcerts'

DOCKER_IMAGE='warriorwiki'


#=====================================================================================

#Install Prerequisites
apt-get -y update
apt-get -y upgrade
apt-get install -y git docker.io openssl
service docker start

#Prepare directories
mkdir -p $BASE_DIR
mkdir -p $DATA_DIR
mkdir -p $MW_DIR

#Clone the warriorwiki repo
cd $BASE_DIR
git clone ${GIT_REPO} src/

#Clone the mediawiki repo
cd `dirname $MW_DIR`
git clone ${MW_REPO} `basename $MW_DIR`
#Install the vector skin
cd $MW_DIR/skins
wget https://extdist.wmflabs.org/dist/skins/Vector-REL1_24-9ace28f.tar.gz -O Vector.tar.gz
tar xvfz Vector.tar.gz

#Create the secret key for MySQL
mkdir -p ${PRIVATE_DIR}
chmod 400 ${PRIVATE_DIR}
MYSQL_PASS_FILE=${PRIVATE_DIR}/mysql_pass.txt
dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 | rev | cut -b 2- | rev > ${MYSQL_PASS_FILE}
chmod 400 ${MYSQL_PASS_FILE}

#Restore a backup of an existing MySQL DB
if [ -n "$MYSQL_PREVIOUS_BACKUP" ]; then
    read -p "Removing any existing database in '${DATABASE_DIR}'. Is this OK? y/N" -n 1 -r
    echo    # (optional) moves to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Restoring the backup MySQL DB from '${MYSQL_PREVIOUS_BACKUP}' to '${DATABASE_DIR}'"
        docker run -d --name mysql_restore -v ${DATABASE_DIR}:/var/lib/mysql -v ${MYSQL_PREVIOUS_BACKUP_DIR}:/bak -e MYSQL_ROOT_PASSWORD=`cat ${MYSQL_PASS_FILE}` -e MYSQL_DATABASE=${DATABASE_NAME} -d mysql
        
        docker exec -i -t mysql_restore bash -c "mysql -u root --password=`cat ${MYSQL_PASS_FILE}` ${DATABASE_NAME} < /bak/${MYSQL_PREVIOUS_BACKUP_FILE}"
        docker stop mysql_restore && docker rm mysql_restore
    else
        echo "Skipping the restore of backup MySQL DB due to user request."
    fi
fi

#Start the MySQL Docker image
docker run --name mysql -v ${DATABASE_DIR}:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=`cat ${MYSQL_PASS_FILE}` -d mysql

#Build The Warrior Wiki Docker Image
cd $BASE_DIR/src/docker
docker build -t ${DOCKER_IMAGE} .

#Create a placeholder self-signed certificate
mkdir -p ${SSL_CERT_DIR}
cd ${SSL_CERT_DIR}
openssl genrsa -out ${DNS_NAME}.key 4096
chmod 400 ${DNS_NAME}.key
openssl req -new -x509 -sha256 -days 365 -nodes -subj "/C=CA/ST=Ontario/L=Waterloo/O=The Warrior Wiki/CN=${DNS_NAME}" -out ${DNS_NAME}.crt -key ${DNS_NAME}.key

#Start the Mediawiki
docker run -d -p 80:80 -p 443:443 -v ${MW_DIR}:/src/mediawiki -v ${IMAGES_DIR}:/src/mediawiki/images -v ${SSL_CERT_DIR}:/etc/ssl/localcerts --link mysql:mysql -e MYSQL_PASSWORD=`cat ${MYSQL_PASS_FILE}` --name=${DOCKER_IMAGE} ${DOCKER_IMAGE}
