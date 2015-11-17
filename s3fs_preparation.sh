#!/bin/bash
set -e

#Make sure that ~/.passwd-s3fs is in place before this script runs
#This script cannot be run during the build phase of a Docker image.
#It can be run during the run phase of a Docker container, but only if the container is given the --privileged flag.
#`docker build` doesn't support the --privileged flag (see https://github.com/docker/docker/issues/1916), so it can't be used during the build phase.

#Make sure the required variables are set.
for env_var in "S3_CACHE_DIR" "IMAGES_DIR" "FILES_SUBDOMAIN"
do
    name="${env_var}"
    if [ -z "${!name}" ]; then
        echo "${env_var} not set. Will not continue." 1>&2
        exit 1;
    fi
done

if [ -e "`eval echo ~/.passwd-s3fs`" ]
then
    #Install fusefs and S3 driver
    ./s3fs_install.sh

    if [ ! -e ${S3_CACHE_DIR} ]
    then
        #Mount the S3 bucket as a partition
        mkdir -p ${S3_CACHE_DIR}
        chmod 700 ${S3_CACHE_DIR}
        mkdir -p ${IMAGES_DIR}
        s3fs -o allow_other,use_cache=${S3_CACHE_DIR} ${FILES_SUBDOMAIN} ${IMAGES_DIR}
    else
        echo "'${S3_CACHE_DIR}' already exists. We're not go to try to mount it again."
    fi
else
    echo "~/.passwd-s3fs must exist so we know how to connect to the bucket." 1>&2
    exit 1
fi