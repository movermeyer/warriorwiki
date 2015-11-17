#!/bin/bash
set -e

#=====================================================================================

export BASE_DIR='/usr/local/warriorwiki'
export DATA_DIR='/usr/local/data'
export MW_DIR='/usr/local/mediawiki'

export GIT_REPO='https://github.com/movermeyer/warriorwiki.git'
export MW_REPO='https://github.com/movermeyer/mediawiki.git'

export DNS_NAME='warriorwiki.ca'
export FILES_SUBDOMAIN=files.${DNS_NAME}

export DATABASE_NAME='warriorwiki'
export DATABASE_DIR=$DATA_DIR/db

export S3FS_FUSE_VERSION=1.79
export S3_CACHE_DIR="/tmp/s3_cache/${FILES_SUBDOMAIN}"
export IMAGES_DIR="${DATA_DIR}/${FILES_SUBDOMAIN}"

export WW_SSL_CERT_DIR='/etc/ssl/localcerts'
export PRIVATE_DIR=${BASE_DIR}/private
export MYSQL_PASS_FILE=${PRIVATE_DIR}/mysql_pass.txt

export DOCKER_IMAGE='warriorwiki'

export MEDIAWIKI_VERSION_MAJOR=1.25
export MEDIAWIKI_VERSION_FULL=1.25.3
export MEDIAWIKI_RELEASE_TAG=REL1_25

export UBUNTU_VERSION_CODENAME="wily"

#=====================================================================================

exec "$@"