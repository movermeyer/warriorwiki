#!/bin/bash
set -e

docker run -d -p 80:80 -p 443:443 -v ${MW_DIR}:/src/mediawiki -v ${IMAGES_DIR}:/src/mediawiki/images -v ${WW_SSL_CERT_DIR}:/etc/ssl/localcerts --link mysql:mysql -e MYSQL_PASSWORD=`cat ${MYSQL_PASS_FILE}` --name=${DOCKER_IMAGE} ${DOCKER_IMAGE}