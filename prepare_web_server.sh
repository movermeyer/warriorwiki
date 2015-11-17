#!/bin/bash
set -e

#This script is to be run on any machine that you intend to run The Warrior Wiki mediawiki image on.

#Make sure the required variables are set.
for env_var in "MW_DIR" "MEDIAWIKI_VERSION_MAJOR" "MEDIAWIKI_VERSION_FULL"
do
    name="${env_var}"
    if [ -z "${!name}" ]; then
        echo "${env_var} not set. Will not continue." 1>&2
        exit 1;
    fi
done

if [ ! -e "${MW_DIR}" ]; then
    #Install Mediawiki
    cd `dirname $MW_DIR`
    wget http://releases.wikimedia.org/mediawiki/${MEDIAWIKI_VERSION_MAJOR}/mediawiki-${MEDIAWIKI_VERSION_FULL}.tar.gz
    tar xvfz mediawiki-${MEDIAWIKI_VERSION_FULL}.tar.gz
    ln -s mediawiki-${MEDIAWIKI_VERSION_FULL} mediawiki
    rm -f mediawiki-${MEDIAWIKI_VERSION_FULL}.tar.gz
else
    echo "${MW_DIR} already exists. We will use that instead."
fi

if [ ! -e "${BASE_DIR}/src" ]; then
    cd $BASE_DIR
    git clone ${GIT_REPO} src
else
    echo "${BASE_DIR}/src already exists. We will use that to create the Docker image."
fi


