#!/bin/bash
set -e

#Make sure the required variables are set.
for env_var in "S3FS_FUSE_VERSION"
do
    name="${env_var}"
    if [ -z "${!name}" ]; then
        echo "${env_var} not set. Will not continue." 1>&2
        exit 1;
    fi
done

apt-get install -y build-essential libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool pkg-config libssl-dev
mkdir s3_compilation
cd s3_compilation

wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v${S3FS_FUSE_VERSION}.tar.gz
tar xvfz *.tar.gz
cd s3fs-fuse*
./autogen.sh
./configure --prefix=/usr --with-openssl
make
make install

cd ../../
rm -rf s3_compilation